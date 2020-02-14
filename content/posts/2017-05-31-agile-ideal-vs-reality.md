+++
title = "Agile: Ideal vs. Reality"
date = "2017-05-31"
slug = "agile-ideal-vs-reality"
+++

<small><i>
<b>DISCLAIMER</b>: This is the internet, a lot of people travel it's seas. This article represents my
own opinion based on my current/past work experience. It is ok if you disagree with me, it's
actually likely you will.
</i></small>

I'd like to argue that nowadays many companies adopted Agile as their "software development
methodology" but have greatly diverged from Agile's original intent. Enough so that it's
gotten hard to even relate the original Agile manifesto with how startups build software.

As a refresher here is the original Agile manifesto:

> **Individuals and interactions** over processes and tools<br>
> **Working software** over comprehensive documentation<br>
> **Customer collaboration** over contract negotiation<br>
> **Responding to change** over following a plan

### Methodology or Values?

First of all, the [Agile manifesto](http://agilemanifesto.org/) never was a methodology.
It's a set of values. The problem is that over the years it's been heavily commercialized,
books were written, formations were created, consultants were trained, roles were invented.
This resulted in a very lucrative business promising the original benefits of Agile but consistently
under-delivering on them.

To a fresh pair of eyes, the whole process of "doing Agile" seems so bloated and full complex
processes and meetings. _We made the process of building software into something rigid and
structured which are exactly the prevailing properties of Waterfall that the Agile manifesto
was trying to avoid._

### Processes

Focusing on the first 25% of the manifesto: **"Individuals and interactions over processes and
tools"**, the processes introduced by modern Agile are not all that bad. It still gets developers,
managers, and PMs interacting in order to build software. Them problem is how codified those
interactions have become. Sprint Planning, Daily Scrum, Sprint Review / Demo, Sprint Retrospective,
Backlog grooming all add up when on a 2 weeks schedule but more important is how much value (or
how little in some cases) is extracted from these.

**Daily Scrum / Standup** seems like a nice idea, keeps everybody in sync, it's a good place to voice
blockers. But, in reality when your team is made up of 3-5 developers working on the same project,
constantly reviewing each other's code: you know what they are up to. If you hit a blocker or even
if you envision a possible blocker coming I would it's expected that you speak up and go find
the people/solution you need to unblock your work, waiting till 9 AM next morning makes no sense
especially that the problem won't even be addressed during standup as it's not the place for longer
1-1 discussions. Standup gains in value when your team getting bigger and you don't know what
everybody is working on, but, that team size brings a lot of other pains with it, small
self-organized and self-sufficient teams seem to work best in practice.

**Sprint Review** in the context of a startup/product company (in contrast with a consultancy) looses
a lot of it's meaning. Your clients are out there and by the thousand, they also don't care about
the technical tasks you've done this sprint. They don't care for half done features either.
Deploying a new feature and writing a blog post about it is the equivalent of a Sprint Review for
a product company.

**Sprint Retrospective** is useful, but having a set time to do so seems backwards. Retrospectives
should always be happening: when there is something to retrospect on! Team members should always
be thinking about processes, wins, and failures. If something feels wrong or something seems worth
celebrating you should feel empowered to speak up right there and then not a set one hour meeting
every two weeks.

**Sprint Planning**'s goal is a useful exercise but the way it's normally done seems more harmful
than helpful, the next section will expand on why I think it's that way...

### Planning

There is no denying planning is valuable, it's also **very hard**.

_First_, humans are quite ill-equipped to **predict the future**, it's really
difficult to divorce your thinking from the present and imagine what the future
could look like.

_Second_, in software, there will always be **surprises**, things you initially
thought was simple but happen to be a lot more involving.

_Third_, **details and polish** is extremely time-consuming, Power Law is in
full effect here, you can get a minimal solution done in 20% of the time, it'll
do 80% of the job but getting to a point where you are satisfied with your
  solution, that last 20%, will take 4 times more time than that initial
  version.

So given it's valuable but hard to get right, you want to do enough planning that you get value out
of it but not so much that extra efforts expended are rendered useless (or worse detrimental).

The main knob you have control over is the level of details you go into while planning. At the very
high level you have company goals, then increasing the level of detail: roadmap, project, feature,
task, class, line of code. The further down that list you go and the more detailed you make each of
those items the **predicting the future** you are trying to do. Don't forget, **surprises** are
inevitable.

Now, what's the point in cutting up projects in detailed features and features in small tasks when
the moment one of the smart engineers you hired is faced with starting to work on these he'll
painstakingly figure out the original assumptions were wrong and 50% of the tasks are wrong in their
definition, 25% are not needed and can be deleted and 25% were missing and not even planned for.

To reiterate the Agile manifesto: **"Responding to change over following a plan"**.

### Conclusion

I get that management wants a measure of how long projects will take. I get that for endeavors
involving multiple teams they want to order dependencies to avoid teams waiting on other teams.
But, I would argue that if you took all that process, all those meetings, all those conservative
estimates, all that top-down task splitting, all that engineer protectionism and threw a whole
project at them from the get go, you would be amazed by how fast it will materialize and how quick
an initial version would be launched.*

It's important to keep **"Working software over comprehensive documentation"** in mind, if your
detailed plan starts with a perfect Part1 followed by a perfect Part2 ... Part3 then at each stage
there is nothing you can ship to customers. What you want is a skeleton of Part 1, 2 and 3, then
improvements to all parts the next month and so on. This avoids a lot of re-work.

When planning in advance we try and think of all that's needed but so much of that work goes down
the drain as requirements will change, third party APIs will not work as you expect, and integration
points with other teams are more complex than you envision. Letting smart engineers figure this out
as they go is the most efficient way of making progress and limiting wasted time.

<small>
_* That is, given you hired smart programmers, motivated by hard problems, able to handle autonomy._
</small>
