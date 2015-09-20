+++
title = "Post mortem: BigDataWeek Montreal Hackathon"
date = "2015-04-30"
slug = "post-mortem-bdm-hackathon"
+++

The least we can say is Montreal is getting pretty lively in terms of thriving
tech community plenty of events! During the week of the 20th of April 2015
Montreal was hosting it's second edition of the **Big Data Week** an global
event happening once a year in more than 40 cities now!

Participating to the 24h hackthon they were organizing on Saturday and Sunday
was promising to be interesting as the mix of persons attending was very varied,
as much as you had data scientist, you could meet students, developers or simply
people interested and involved in different ways with data.

This time, lacking experience with the domain and having a few technologies in
mind, I decided to do things differently and approach this weekend more as a pure,
learning opportunity. The outcome was really interesting and satisfying on a
personal level.

## The project

Hours before the start of the hackathon I discovered the [GHTorrent](http://ghtorrent.org)
dataset, a historical archive of GitHub's public event timeline dating back to 2012.
This dataset includes repos, commits, users, issues, comments, pull-requests and
more, all that in the form of **BSON** dumps in 2 months increments originating
from their **6.5TB MongoDB cluster**.

The project I had is mind was _find what traits makes successful open-source projects
that successful, is it the top contributer? the speed at which they close issues?
the comments on pull-requests? quality of commits? is it company backed?_. **But**,
I quickly discovered that it's not that easy to iterate on this kind of insight
research without a good way to run code/analytics against the whole dataset quickly,
except when the whole dataset fits in memory which wasn't the case.

So, what I set out to do was build a **horizontally scalable**, **real-time**,
**stream parsing**, **clustured deployment** for **rapid iteration** on **big data
sets**. Wow fancy. Much buzzwords. So cool.

But, it quickly became clear that doing all this would take up way more time than
24 hours, especially iterating on the ways of interpreting the data plus making
nice visualisations. So, I ended up only working on infrastructure and ops with
tools like:

- Terraform
- Ansible
- DigitalOcean
- FreeBSD
- nsq.io
- Golang
- InfluxDB
- Grafana
- Riak
- Nginx

## Takeaways

I had a total blast navigating docs, messing with 20 servers at the same time,
fiddling with new libraries and meeting nice people. Also, **winning** the Solo
Developer prize was really nice and totally unexpected.

I also learnt the hard way that SaaSes and platforms that exists are really there
to save you tons of time, removing a lot of manual work from your plate, but,
on the other side, I also really wanted to deal with provisioning my own servers
and datastores to see how it's done.

Lastly, I must say my encounter with **Riak** was really short but I am definitively
investing more time in this datastore really soon!

## TL;DR

- Big Data involves way more than engineers and data scientists
- A lot of interesting huge datasets exist in the open
- Hackathons are a great source of social, fun and new technical challenges
- Big Data platforms exist for a good reason, a lot work is involved in each step
- The co-working space [LaGare](http://garemtl.com/) is really neat looking!

<script async class="speakerdeck-embed" data-id="e54ce2baaac14f2fb1a7bee125fa68b5" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
