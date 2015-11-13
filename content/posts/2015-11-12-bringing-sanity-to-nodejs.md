+++
title = "Bringing sanity to large scale Node.js applications"
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

```
import Container from './lib/contrainer';
export default new Container();
```

Then, in your `app.js` you can register libraries you want to make available to
the following classes you'll register/use.

<script src="https://gist.github.com/kiasaki/263e69a36a523cfef7ac.js"></script>

The final piece being the DI container it-self. I tried making it as compact as
possible.

<script src="https://gist.github.com/kiasaki/95b96d4d1710cfc5abb4.js"></script>


## Repositories and Entities instead of large Models


