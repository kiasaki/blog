+++
title = "Bringing sanity to growing Node.js applications"
date = "2015-11-12T21:07:37-05:00"
slug = "bringing-sanity-to-nodejs-apps"
+++

It seems like most of the content written and blogged about Node.js, even now,
6 years in, takes a really basic approach to showing you how to build applications.

A lot of Node.js articles explain **Express.js** the leading web framework,
the problem is, this framework is comparable to **Sinatra** in Ruby or **Flask**
in Python or **Silex** in PHP. Good for small few pages website, basically gives
you _routing_ and an _interface to HTTP_ but not much more.

Now Ruby, Python and others have bigger frameworks that are well suited for larger
project where you benefits from more _architecture_, opinionated _defaults_ and
supporting modules (ORMs, utilities, rendering, mailing, background workers, assets
pipelines). The story is a bit different in **Node.js** as it promotes small npm
modules (i.e. gems, packages) that you put together by yourself, which, is a good
thing, most experienced developers prefer libraries over frameworks, but, there
is no literature or examples of how this can be done within the Node.js ecosystem.

So, to solve this, let's try and define few libraries or simple files that can
help us out with our growing codebase.

## Goals

The goals here are to have something easier to maintain than an `app.js` file,
a `routes/`, `models/` and `views/` folder that's it. To achieve this we are going
to go on a hunt and steal few time tested tricks from other ecosystems.

## Dependency injection

Some people seem to dread this one, others love it. Having experienced it a lot
in **Laravel** a great framework for PHP and in Java in quite a few places,
dependency injection can help keep all our application parts and files decoupled.
Leading to way easier unit testing and modification of dependencies.

The concept is, all of your request handlers/controllers have dependencies,
your models/repositories/entities too, you could go and hard code them by requiring
the right file and using it but if you let a _dependency injection container_
do it for you, you can more easily change that required components by a different
implementation of it and, when testing, you can directly pass in stubs/mocks
without any trickery or magic.

So, how would we go about implementing this?

First step is to have a file that represents the global instance of the _container_.
That is, where all instances will be stored and the tool that resolve needed
dependencies when you'll want to instantiate a controller.

It would look like this:

```javascript
import Container from './lib/contrainer';
export default new Container();
```

Then, in your `app.js` you can register libraries you want to make available to
the following classes you'll register/use.

```javascript
import express from 'express';
import container from './container';

let app = express();
// ... middlewares, config ...

// Manually setting intance
import EventEmitter from 'events';
container.set('events', new EventEmitter());

// Automatically resolving dependencies and setting an instance
container.load(require('./lib/config'));
container.load(require('./lib/db'));
container.load(require('./lib/auth'));
container.load(require('./repositories/user'));
container.load(require('./services/billing'));

// Using container to resolve dependencies but
// giving back the instance insted of setting it.
let requireUser = contrainer.get('auth').requireUserMiddleware;
let userController = container.create(require('./controllers/user'));
app.get('/users/:id', requireUser, userController.showUser);
app.get('/users/create', requireUser, userController.showCreateUser);
app.post('/users', requireUser, userController.createUser);

// ... error handling ...

app.listen(contrainer.get('config').get('port'));
container.get('events').emit('app:started');
```

_(When you grow to have many more routes, extracting those to their own `routes.js`
is a good idea)_

The final piece being the DI container it-self. I tried making it as compact as
possible.

```javascript
import R from 'ramda';

export default class Container {
  constructor() {
    this.contents = {};
  }

  get(name) {
    if (!(name in this.contents)) {
      throw Error('Container has nothing registered for key ' + name);
    }
    return this.contents[name];
  }

  set(name, instance) {
    this.contents[name] = instance;
  }

  create(klass) {
    if (!('length' in klass.dependencies)) {
      throw new Error('Invariant: container can\'t resolve a class without dependencies');
    }

    var dependencies = R.map(function(dependencyName) {
      return this.get(dependencyName);
    }.bind(this), klass.dependencies);

    return applyToConstructor(klass, dependencies)
  }

  load(klass) {
    if (typeof klass.dependencyName !== 'string') {
      throw new Error('Invariant: container can\'t resolve a class without a name');
    }

    this.set(klass.dependencyName, this.create(klass));
  }

  unset(name) {
    delete this.contents[name]
  }

  reset() {
    this.contents = {};
  }
}

function applyToConstructor(constructor, args) {
  var newObj = Object.create(constructor.prototype);
  var constructorReturn = constructor.apply(newObj, args);

  // Some constructors return a value; let's make sure we use it!
  return constructorReturn !== undefined ? constructorReturn : newObj;
}
```

## Repositories, Entities and Services instead of large Models

It's been told on many blog posts and talks for a good while now that fat models
are evil. The **ActiveRecord** pattern that's so prevalent in Rails and many ORMs
is easily replaced by separating concerns:

- **Data representation** goes in _models_. Those are as dump as possible, optimally
  immutable.
- **Fetching/Saving/Database interactions** are made in _repositories_. Those take
  plain models and knows how to persist them and query datastores.
- **Business logic** goes into _services_. Services is the place where most of
  the complexity resides, it's what controllers call with input, what validates
  business rules, what's calling repositories and external apis.

To give concrete examples:

An **entity** is a simple POJO/PORO/POCO...

```javascript
import R from 'ramda';

export default class InvoiceLine {
  constructor(params) {
    R.mapObjIndexed((v, k) => this[k] = v, R.merge(User.defaults, params));
  }

  taxAmount() {
    return this.price * this.taxes;
  }

  total() {
    return this.price + this.taxAmount();
  }
}
InvoiceLine.defaults = {price: 0, taxes: 0.15, created: Date.now()};
```

A **repository** will most likely take a database object in it's constructor to
be able to interact with the datastore. Repositories are singletons loaded once
when stating the app using the container's `load` method.

```javascript
import User from '../entities/user';
const TABLE_NAME = 'users';

export default class UserRepository {
  constructor(db) {
    this.db = db;
  }

  findByEmail(email) {
    return this.db.select('id, name, email, ...')
      .from(TABLE_NAME)
      .where('email = ?', email)
      .limit(1)
      .exec();
  }
}
UserRepository.dependencyName = 'repositories:user';
UserRepository.dependencies = ['db'];
```

A service is the simplest of the 3 in form but the one in which most complexity
will hide. It simply has instance methods and dependencies listed to it can be
registered in the container for controllers to depend on.

```javascript
export default class BillingService {
  constructor(userRepository, stripeService, mailer) {
    this.userRepository = userRepository;
    this.stripeService = stripeService;
    this.mailer = mailer;
  }

  createNewAccout(name, email, password, stripeToken) {
    // validate
    // create user
    // create stripe customer
    // update db user
    // send welcome email
    // ...
  }

  // ...
}
BillingService.dependencyName = 'services:billing';
BillingService.dependencies = [
  'repositories:user', 'services:stripe', 'mailer'
];
```

## Slimmer Controllers in favor of Services

Now that we have a dedicated place to put business logic, you should aim to slim
down those controllers to their essential job: mapping requests and the http
protocol oddities to method calls/actions to be taken.

This simple action has the new benefit of decoupling yourself from the transport
protocol enabling reuse of all that business logic by other consumers like:
background workers, a websocket endpoint, a protobuff endpoint even a separate
codebase if you decide to extract the core of your app into a library when you
grow bigger.

## Factories

As your project grows and your entities become more complex you may come to a
point where you find yourself spending a lot of lines initializing entities in
your services, it's a good idea to extract those to factories. Those object will
give you a clean way to encapsulate complex entity construction with many branches.

## The `lib` folder still exists

Not everything fits into the concepts we just went over, there are few middlewares,
really simple libs or wrapper and definitively have their place in your `lib`
folder, just try to keep it lean and mean, most of your code is supposed to be
elsewhere.

## Conclusion

I hope this post gave you ideas on how to reduce the size and complexity of your
routes files/folder. Code organization (/architecture) starts simple in a new
project but **needs** to grow linearly as your project matures or your productivity
will suffer quite a bit.

I would love to know how you deal with growing codebases too! DM on Twitter or
send me an email.
