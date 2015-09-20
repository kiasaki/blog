+++
title = "Welcome to Hugo!"
date = "2015-09-19"
slug = "welcome-to-hugo"
+++

It's been a little while I wanted to switch to a new bloging platform. My old
solution was a tool a built myself (often unwise when a lot already exists) and
was pretty basic. It got the job done, but did really have space for growth.

I am now joining the ranks of people using the _static website generator_ called
**[Hugo](http://gohugo.io)**. Advantages it encompasses go from blazing fast
compilation, by more than simply bloging, to simple in design but infinite in
possibilities with concepts like content types (not plain blog posts) and taxonomies).
Making themes for it was not an afterthought and was really well designed.

This was an occasion to try something new design wise, I wanted something more
simple, a different layout, and, mainly, simple CSS and a serif font.

# How hard is it?

Well, Hugo is a bit different in the way it approaches content but still easy to
understand if you come from other static website generators like Jekyll or Metalsmith.

For a new site simply invoke (from the command like)

    hugo new site <FOLDER>

When I wish to create a new post I type:

    hugo new posts/2015-09-18-welcome-to-hugo.md

I will then base itself from the template at `_archetypes/default.md` and fill
in the title and current date for me.

Next, firing up a development server is as simple as:

    hugo server --buildDrafts -w

The `--buildDrafts` ensure you preview the posts that have `draft = true` in their
metadata, allowing you to work on posts, put them on hold, and still keep publishing
other posts.

When ready to publish something you simply invoke:

    hugo

This will generate all the necessary html & static assets in the `public` directory
that you can them upload or commit to Github Pages.

Hope this makes it less scary to get into! Hugo has good documentation as really
is a seriously good option in the market of static site generators used for blogs.
