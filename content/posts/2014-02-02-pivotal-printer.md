+++
title = "Presenting you Pivotal Printer"
date = "2014-02-02"
slug = "pivotal-printer"
+++

_[Pivotal Printer](http://pp.kiasaki.com/) is a simple tool to export your user stories as a nice PDF_

Built quickly & still work in progress this simple website will help you print your user stories as neat little cards. The little sinatra app powering it is also open source & [available](https://github.com/kiasaki/pivotal-printer) on GitHub. Feel free to submit pull requests.

## How does it work?

It's fuelled by a great singer & has unicorn's filling your requested pdf's in the background. Actually, it's almost like described in that first sentence, as a framework I used sinatra, the app being in one small file (`app.rb`) all route handling and dispatching occurs there.

For getting your _Pivotal Tracker_ projects & cards I use the `pivotal-tracker` gem which abstracts any interaction needed with PT's api in neat ruby classes. A quick rundown of how I used it can be seen in the following snippet:

    PivotalTracker::Client.token = "<your api key here>"
    @projects = PivotalTracker::Project.all

    # Find all stories for the first project's first iteration
    @stories = @projects.first.stories.all

    # Or you could even filter out stories by different criterias
    @feature_stories = @projects.first.stories.all(:story_type => 'feature')


As for actually generating the pdf I based my code on __karmi__'s great little script (it can be found [here](http://karmi.tumblr.com/post/622136360/create-printable-pdf-cards-for-your-pivotal-tracker-stor)). It mainly uses the `prawn` ruby gem to write on the pdf & align everything on a grid. The code handling this part has been extracted to the `pdf.rb` file that can be consulted [here](https://github.com/kiasaki/pivotal-printer/blob/master/pdf.rb).

That's all there is to it. I hope I get more time to improve the filtering features & add more customizations.

Happy hacking!
