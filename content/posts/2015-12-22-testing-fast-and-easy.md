+++
title = "Testing web applications made fast and easy"
date = "2015-12-22T21:13:20-05:00"
slug = "testing-made-fast-and-easy"
+++

Many other content already discusses about the advantages of testing. The advice
almost always goes something like this: _"Testing won't add much to development
time but will save your ass more than once on bugs and that's before they even
reach your customers. Plus, it has the nice side effect of making you write
cleaner code if you write tests before code"_.

I am here to talk about the two main pain-points developers have with writing
tests, they are **hard to write** and **lengthen the feedback loop** (especially
with large codebases).

Now those two factors are probably the biggest detractors of, **first**, the
people looking to get into testing and TDD and, for the **second**, people
writing test but hating it as their test suite is so slow it can take 1 hour
to run.

That often leads to you pushing to the CI and hoping what you wrote didn't
break anything elsewhere, it's an hour wait so you context switch to an other
task, come back to it later, it failed, re-checkout the git branch fix the
little details, push again...

---

Now, I am no different and here is what I propose: ~80% of tests you write are
unit tests. That is 80% of tests you **write** and, in terms, ~80% of the
**running time** of your test suite. Why not, forget about a real database,
forget about HTTP, forget about all dependencies mock them all and only run
(in Node.js's case) pure JavaScript across just the few lines in the function
you are currently testing, no other part of the codebase.

Here, let's say you have this controller with a method fetching a list of users:

```
class UsersController {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  users(req, res) {
    const limit = req.query.limit || 20;
    const order = req.query.order || 'created';

    return this.userRepository.find({limit, order})
      .then(users => {
        res.status(200);
        res.json({data: users});
      }, next)
  }
}
```

Now, the route most often taken to test this part of the code is to reach out
for a library to do an _http request_ and make sure you have a _test database setup_
and also _create few models_ so that you know what to look for in the controller's
response, all while making sure the _database tables are cleared in between tests_
as you don't want all those models from other tests showing up in the controllers
response...

A lot to think about, a lot of setup, quite slow because of all the
moving components and really, looks more like integration testing (which you
should still be doing here and there) than unit testing.

---

How about creating a fake request object and a fake response, and just for this
controller a fake `userRepository` that will help us verify that for a given
input, the correct calls are made by the piece of code being tested.

```
// fake-request.js
class FakeRequest {
  constructor() {
    this.query = {};
    this.body = {};
    this.params = {};
  }
}
```

```
// fake-response.js
class FakeResponse {
  constructor() {
    this.statusCode = 200;
    this.jsonBody = null;
    this.endCalled = false;
  }

  json(value) {
    this.jsonBody = value;
  }

  status(code) {
    this.statusCode = code;
  }

  end() {
    this.endCalled = true;
  }

  // ...
}
```

Then with those two you can start writing a test specific to that controller's
`users` method:

```
// test/controllers/users.js
const assert = require('assert');
const FakeRequest = require('...');
const FakeResponse = require('...');
const UsersController = require('...');

describe('controllers:users', () => {
  let fakeUserRepository = {};
  let fakeRequest;
  let fakeResponse;
  let fakeNext;
  let usersContoller;

  beforeEach(() => {
    usersContoller = new UsersController(fakeUserRepository);
    fakeRequest = new FakeRequest();
    fakeResponse = new FakeResponse();

    fakeUserRepository.findOptions = null;
    fakeUserRepository.find = (options) => {
      fakeUserRepository.findOptions = options;
      return Promise.resolve([]);
    };

    fakeNext = (error) => {
      fakeNext.givenError = error;
    };
  });

  describe('users()', () => {
    it('calls userRepository defaulting to a limit of 20', () => {
      return usersContoller.users(fakeRequest, fakeResponse)
        .then(() => {
          assert(fakeUserRepository.findOptions);
          assert.equal(fakeUserRepository.findOptions.limit, 20);
        });
    });

    it('calls userRepository defaulting to ordering by creation date', () => {
      return usersContoller.users(fakeRequest, fakeResponse)
        .then(() => {
          assert(fakeUserRepository.findOptions);
          assert.equal(fakeUserRepository.findOptions.order, 'created');
        });
    });

    it('calls userRepository respecting query parameters', () => {
      fakeRequest.query.limit = 5;
      fakeRequest.query.order = 'name';

      return usersContoller.users(fakeRequest, fakeResponse)
        .then(() => {
          assert(fakeUserRepository.findOptions);
          assert.equal(fakeUserRepository.findOptions.limit, 5);
          assert.equal(fakeUserRepository.findOptions.order, 'name');
        });
    });

    it('calls next on userRepository error', () => {
      fakeUserRepository.find = () => Promise.reject('repo error');

      return usersContoller.users(fakeRequest, fakeResponse, fakeNext)
        .then(() => {
          assert.equal(fakeNext.givenError, 'repo error');
        });
    });

    it('sends the right response', () => {
      const result = [{id: 89, name: 'Jack'}, {id: 41, name: 'Dooey'}];
      fakeUserRepository.find () => Promise.resolve(result);

      return usersContoller.users(fakeRequest, fakeResponse)
        .then(() => {
          assert.equal(fakeResponse.statusCode, 200);
          assert.deepEqual(fakeResponse.jsonBody, {data: result});
        });
    });
  });
});
```

Sorry for the long file, but that's all there is to it, running that test file
takes no more that **2-3 milliseconds**. A full test suite for a bigger project
might be more like 20 seconds, a far cry from 20 minutes.

I know it isn't perfect, there is a lot that happens in between component and
you really can't always write tests verifying exactly the right outputs but
that's why **integration testing** still has it's place, to make sure everything
integrates properly. Just don't do it in place of **actual unit tests** and
as 90% of the test suite.

As always, take this with a grain of salt, your projects are different than
mines for sure, if you find that way of writing minimal unit tests promising
try it out see if it sticks.
