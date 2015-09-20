+++
title = "WTF is Octopress?"
date = "2013-05-10"
slug = "wtf-is-octopress"
+++

After all, it's not such a widespread choice in term of blogging backend/software.

Octopress calls itselft a *'A blogging framework for hackers.'*, and it delivers extly that.

Octopress is not targetted for every one but it's by no means restricted to people with extensive knowlodge of the terminal, git and other geeky tech stuff.

Actually, the set-up I am using was really easy to setup, I cloned *Octopress* on my computer, changed few settings (blog tile, etc.), then I sent them over to [Github](http://github.com) in a newly created repositry called `{username}.github.io` and Voilà!

By pointing my browser to `kiasaki.github.io` I could see my newly created blog!

Then to setup your own custom domain you have to either:

- Change your **top level domain** (e.g. fredericgingras.ca) A record to point to the folowing IP : 204.232.175.78

     — OR —

- Foward (CNAME) your **sub domain** (e.g. blog.fredericgingras.ca) to `{username}.github.io`

## Installation

From now on I will assume that you already have **Ruby** installed and **RubyGems**, plus, the skills to open a terminal window, type in the following eleven characters `gem install` followed by a Gem name.

To start your **Octopess** blog the fisrt step is to clone the source code from **GitHub** to your local machine. This step can easily be done by issuing the folowing command:

```
git clone git://github.com/imathis/octopress.git my-blog
cd my-blog
```

Next step is to install and the dependancies

```
bundle install
```

And, install the `classic` theme using the folowing:

```
rake install
```

Now, in theory, you have a ready to deploy **Octopress** blog.
We can preview our blog using the folowing `rake` commande

```
rake generate
rake preview
```

## Going further

Ok, now that you have the basic structure, you courld just be happy and let it stand there satisified, but it won't be your own blog until you customize it a little bit and and a few posts or pages.

To be continued...
