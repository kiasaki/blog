+++
title = "Coding challenges are exciting!"
date = "2014-10-25"
slug = "coding-challenges-are-exciting"
+++

Not only are coding challenges meaning a potential new and exciting job but they also constitute a fun intellectual activity. This weekend I am to take on two of them. One related to frontend web development and the other to backend web development for a potential full-stack developer position.

In this blog post I will details my thought process as I go along solving the backend coding challenge, in a second post I will details the frontend challenge.

## Backend Coding Challenge C

I will start by doing the backend one beacuse this is what I enjoy the most and will help me get used the whole coding challenge process and way of doing things, this is my first experience in the field.

### Getting started

Ok, let's get to business, first thing I did was reading the [requirements / readme](https://github.com/busbud/coding-challenge-backend-c) two time to be sure I didn't miss anything then I went on reading the Javascript [style guide](https://github.com/busbud/js-style-guide) proposed as the application is to be written in __Node.js__ preferably.

### Requirements

So, from what I understand, I am to write a API endpoint that would be used to search cities by name and score them by proximity if `latitude` and `longitude` parameters are provided.

- The data set provided is composed of North American (read USA and Canada) cities with a population of more than 5000 citizen, I figured out it's about 7000 cities total so, not that big.
- The endpoint answers to the following url: `/suggestions` and takes three optionnal parameters `q` for the search query, `latitiude` and `longitude`.
- If ever there is no results a 404 Not Found status code should be sent back.
- The results should be sorted by descending score, a score being a number between 0 and 1 inclusivly indicating the confidence in the suggestions.
- The final solution should be deployed to heroku
- The final solution should have all functionnal tests passing
- I am allwoed to add other features and improvments

### What will be done and what won't

As in every project, it is always possible to spend an infinite amount of time on it if you don't set yourself specific goal or expected outcomes. Following this challenge requirements here is what I'll aim to do and what I won't do:

__Do__

- Write code in small modules fitting the nodejs mentality
- Test functionnaly those modules so other developers arn't scared of breaking thing when editing code
- Stay concise in the code written so it's easily readable by others
- Value performance right after modular and readable code
- Have the cities loaded in memory
- Use a trie (prefix tree) to index cities names and allow faster searches than the sequential scan of an array / hash table
- If a memcache url is provided store search _results_ in there, common searches will be much faster (not asked for but seems like a must to me, how many time will you compute _New York_ for nothing without a cache?)

__Don't__

- Over complicate the scoring or the indexing of results with multiple algoritms stick with one good and performant one.
- Store the cities in a database, yes this would give me searching for free but would be much slower less flexible that comming up with an in memory representation of the cities. I understand that if we were dealing with a changing dataset I would simply have no choice other than storing it in a database but since cities change far from often were are good with loading the cities from a file on boot.
- Mess with the Zohan

---

## Step 1 : Reding the cities `.tsv`

First things first, I need to load and parse those cities from the tab-separated-value file, for that I first tried using a library called `fast-csv` but ended un settling for his brother named `ya-csv`. I ran in few problems using `fast-csv` and errors were really unclear. After reading both libs source code `ya-csv` came out being really more simple and easy to read for the same set of features, plus it gave me detailed errors compared to the first library.

The Reader function look close to this:

```javascript
function Reader() {
  this.cities = [];
}

Reader.prototype.load = function(path, done) {
  var self = this;
  var csv_load_options = {
    columnsFromHeader: true,
    quote: null,
    escape: null,
    separator: '\t'
  };

  csv.createCsvFileReader(path, csv_load_options)
    .on('data', function(data) {
      if (data.population > 5000) {
        self.cities.push(new City(data));
      }
    })
    .on('end', function() {
      console.log('Finished loading cities.');
      done(self.cities);
    });
};
```

`City` here is a simple pojo with a constructor that picks only the needed fields and transforms the `admin1` and `country` fields with the help of the `lodash` library (faster alternative to `underscore`).

It looks like this, few contstants ommited:

```javascript
function City(params) {
  var params = _.pick(params, CITY_ALLOWED_PARAMS);

  // Set admin1 for canada to 2 letters
  // Original dataset had numbers for canadian provinces
  if (params.country === 'CA') {
    params.admin1 = CANADIAN_PROVINCES[parseInt(params.admin1)];
  }

  // Set country to fullname
  params.country = COUNTRIES[params.country];

  // Assign selected params to ourselves
  _.assign(this, params);
}
```

With those two simple classes hooked up to my app's entrypoint (`app.js`) I `.slice`'d the first 5 cities, outputed them in json, seeing it worked I moved to the next step.

---

## Step 2: Cleaning up the web server and routing

Next up I wanted to extract a little of the boilerplate code related to server answers still without including a fullfleged module like `express` so I created a little function called `sendResponse(body, httpCode)` that will be more than enough for the needs of our endpoint.

The other things I did is, seeing there was already nesting of callback for the sever initialization, I used the `async` library to make all initialization steps in _series_, it's easier to read and comprehend now.

```javascript
async.waterfall([
    function(done) {
      // Load cities
      done(cities);
    },
    function(cities, done) {
      // Tokenize and build tries with cities
      done(cities, search_engine);
    },
    function(cities, search_engine, done) {
      // Create server and start it
      done();
    }
]);
```

---

## Step 3: Storing cities and asigning them ids

The more I thought about the next step, tokenizing city names and storing them on a trie, I thought about having those city object stored alongside every possible search token in the _trie_ and how much memory it would take.

So, before I get to the next step I will ensure that we assign ids to every city and that we store them in something that fast for retrivals by id when sorted. I am thinking of a B-Tree but I am not sure it will be faster than plain old javascript array retrival which behave like a hashtable. So let's do a small benchmark.

```bash
$ node benchmarks/btree-vs-plainarray.js
Array retrival x 34,829,664 ops/sec ±1.02% (90 runs sampled)
Tree retrival x 3,272,637 ops/sec ±0.73% (90 runs sampled)
Fastest is Array retrival
```

From what I can see simple object retrival by key is about 10-fold faster, I think those results come from the fact that the overhead of retrival for 10 000 rows or even 100 000 rows in a javascipt object is negligable comared to the tree version that is, yes, faster, but on paper and with way more objects in it than a mere 10 000, all the added code for each retival add up quick in execution time.

_Sorry, I have been calling one of my candidates **plain array** but it's actually a **javascript object**, we have keys not just values._

In the light of this test I'll simply add **id**'s to the cities and return an object with all of them.

---

## Step 4: Tokenizing search results and storing them in a trie

For this step I know that _Twitter_ did a really good job with their frontend library called **Typeahead.js** and I knew they had that well written suggestion engine called **Bloodhound** comming bundled with it. But, upon reading the source code, the implementation was really tied to the browser and needed adaptation to be ran in _node.js_.

In the light of my last experiment with obejct and b-tree's I'd like to take the same approach here, I will write a simple benchmark along the way that will compare a simple `String#indexOf` a `RegExp#test` and cities in a `Trie` that I am about to write.

Ok so the reasults are in:

```bash
$ node benchmarks/trie-vs-indexof-vs-regexp.js
Finished loading cities.
RegExp search x 2,303 ops/sec ±0.87% (95 runs sampled)
IndexOf search x 1,790 ops/sec ±0.81% (90 runs sampled)
Trie search x 12,931 ops/sec ±0.62% (95 runs sampled)
Fastest is Trie search
```

I ended up using one file of the **Bloodhound** plugin included in **Typeahead.js**, their actual **Trie** implementation located in file `search__index.js` was not tied to the browser and really flexible enough for my needs: you pass in your own tokenizer for the search query AND the searched items. That saved me some time and I most certainly have a better implementation now than one I would of written myself.

On the benchmark results, nothing obivious here, the two first methods do a full scan of the whole data set on every search, exactly what we try to avoid using a Trie. I was still suprised using **RegExp** was faster than **indexOf**. One things I would improve in that benchmark is using different search query than _"mon"_ each time, that is not a problem beacause none of our implementation optimizes for often searched queries but if one did this benchmark would not be representative anymore.

Site note here, that trie implementation even has the advantage of searching all words in a city name not only city names _starting with_ the query. I feelt this was a must seeing all those _Mont-Saint-Hilaire_ here in Québec, searching for _Hilaire_ or _Saint Hilaire_ is much more common.

_Last part of this step is actually implementing this in our app, let's do this!_

Done! This is how the new **Search** class looks at the moment, it's mostly the glue around all the features of this `/suggestions` endpoint: city holder, params sanitizer, caching, actual searching and later result limiting.

```javascript
// ... requires and tokenizer ommited ...

function Search() {
  this.cache = null;
  this.search_index = new SearchIndex({
    datumTokenizer: cityTokenizer,
    queryTokenizer: queryTokenizer
  });
}

Search.prototype._sanitizeSearchParams = function(params) {
  var clean_params;

  clean_params = _.pick(params, ['q', 'latitude', 'longitude']);
  clean_params = _.defaults(clean_params, {
    q: '',
    latitude: null,
    longitude: null
  });

  return clean_params;
}

Search.prototype.add = function(items) {
  this.search_index.add(items);
};

Search.prototype.search = function(params) {
  // Step 1: Sanitize params
  var params = this._sanitizeSearchParams(params);

  // Step 2: Check the cache
  if (this.cache) {
    var cached_results = this.cache.get(params);
    if (cached_results) {
      return cached_results;
    }
  }

  // Step 3: Make the search
  var results = this.search_index.get(params.q);

  // Step 4: Score the search results
  // TODO: Comming up
  var scored_results = results; // this.scorer.score(results, params);

  // Step 5: Remove unnecessary fields from city objects
  var cleaned_results = _.map(scored_results, function(obj) {
    return obj.toObject()
  });

  // Step 5: Cache results
  if (this.cache) {
    this.cache.set(params, cleaned_results);
  }

  // Step 6: We are done
  return cleaned_results;
}
```

Plus, all tests are passing now! Had to do some fiddling in [my commit](https://github.com/kiasaki/coding-challenge-backend-c/commit/ea3be2d1965c8affa47d542594c81371715b88d2) with the tests file so the app gets loaded in async and then tests start ...

---

## Step 5: Scoring

The minimum I wan't the scoring to do in this endpoint is to use the **distance** between the searcher and the results. The second variable I want to influence the score of a result is the **population** of a result. So that _"Deux-Montagnes, QC, Canada"_ won't come before _"Montreal, QC, Canada"_.

Scoring needs to happen each time a request comes in beacause only at that moment we have access to the users location.

Yes we could precompute the population score but that would be much of an optimization, it's simple math operation, I is more prone to complexify the codebase and make it less easy to read and grasp.

Ok so this is rock and roll and quite procedural, at first I decided on the weight each metric has by defining few constants:

```javascript
var SCORE_GEO_WEIGHT = 5;
var SCORE_POP_WEIGHT = 1;
var SCORE_TOTAL_WEIGHT = SCORE_POP_WEIGHT + SCORE_GEO_WEIGHT;
```

That way we can calculate indivitual metrics score like this:

```javascript
var population_score = /* calculate score and bring back to a scale of 0 to 1 */;
result.score += population_score * (SCORE_POP_WEIGHT / SCORE_TOTAL_WEIGHT);
```

And later the same thing with an other metric, that way I can tweak their important without finding every occurences I entered mannualy the weight of that metric;

**To calculate the population score** I decided on what I is consided like a huge enough city to and capped city population to that number like so `Math.min(population, POP_CAP)` than means that we can now divide this by the decided `POP_CAP` and we will never get a value over 1 while keeping lower values not too small so that they don't make any difference in the score. Ex: what I decided on beaing a big city is more that 3 000 000 citizens, so a 50 000 city compared to that number is still a big one sixtieth, it would of been much smaller I we used the maximum population of our whole dataset.

**To calculate the distance score** I calculated the distance between the origin of the search and the city's location, then, divided the distance by the maximal distance between two points on Earth so I get a normalized value between 0 and 1. Then substracted the resultant from 1 so that closer to origin equates to better score.

---

## Step 6: Caching

So in step 4 search code exemple I already placed pointers on were is the cache going to fit in the big picture.

What is left to do is implement it, this may seem basic stuff but here's how it works: I build a unique key using all search params, in our case `q`, `latitude`, `longitude`, `limit` and store the final search results in a cache database like `memcached` before returning an http response. On the next search using those exact params we will be able to retrive the results from the cache without computing them. Yay!

Ok, done, [here's the commit](https://github.com/kiasaki/coding-challenge-backend-c/commit/9d3d2cb0d86b5b6df21a46f3342446a3b4fe5563) although, I am not sure adding cache for this use case was the best idea. It added a lot of complexity to the `Search.prototype.search` method that now contains a huge `async.waterfall` definition beacause of the async cache code and and possible errors thrown. That are, yet, far from beeing all handled.

Plus, after a little of testing with the `ab` utility (apache bench), on small loads the version without cache was constently 20ms faster. More benchmarking should be done, after all we are not doing heavy computations that really need to be cached, that trie search and few math operations is all we do.

---

## Step 7: Extra feature: Limiting

I felt limiting was a need to have so those autocomplete text box don't fetch 10 000 results when they do 2 letter searches. It was as simple as adding a function in the `Search.prototype.search` method: [here](https://github.com/kiasaki/coding-challenge-backend-c/commit/9ee6b50aae5e2eb0895fb5b0f6d704cc7adc9621).

It looks a bit like that:

```javascript
// Step 6: Limit the results
function(params, cached_results, cleaned_results, callback) {
  var limited_results = cleaned_results;

  // If we have a limti and we are serving uncached results
  // limit the results using slice
  if (params.limit && cleaned_results) {
    var limit = Math.min(params.limit, limited_results.length);
    limited_results = limited_results.slice(0, limit);
  }

  callback(null, params, cached_results, limited_results);
},
```

---

## Step 8: Deploying to Heroku

Simple enough I thought,

```bash
$ git add -A
$ git commit
$ hk create <cute-name>
$ git push heroku <feature-branch>:master
$ open https://<cute-name>.herokuapp.com/
# :( It crashes
$ hk log
$ hk log -n 40
# Still don't understand
```

It's always like that, thing you are used to do and seem simple always end up breaking apart on you. So here I am looking at the logs and changing few things here and there, exploring possible culprits, util, after installing libs, running bash in the heroku node, installing Logentries, I figured out it was all about this: [the app was binding on 127.0.0.1](https://github.com/kiasaki/coding-challenge-backend-c/commit/99ce94a4b0bb9e75b378e579dac0b517bd2bc01f) and heroku was sigkill'ing my process thinking I failed to boot.

Now we can visit [http://na-city-suggestions.herokuapp.com/suggestions?q=lon](http://na-city-suggestions.herokuapp.com/suggestions?q=lon&latitude=47.40177&longitude=-122&limit=2) safely.

---

I am done for this blog post, merging back into master and sending a pull-request, my time is out!

I will probably end up writing few tests and adding documentation even after that but will not write about it, check out the repo if you wish.
