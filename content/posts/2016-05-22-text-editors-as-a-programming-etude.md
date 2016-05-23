+++
title = "Text editor implementation as a programming étude"
date = "2016-05-22T20:03:35-04:00"
slug = "text-editor-implementation-as-a-programming-etude"
+++

If you're a programmer yourself and are looking to improve your skills, I would
like to propose to generally "deliberately practice" your craft, in the sense
"repeatedly attack problems at the edge of you capabilities in an exercise context, not at
work". And, as finding personal project ideas can be quite tricky for some,
I would like to propose _implementing a text editor_ as a really good project
choice.

Now this proposition makes sense, in my opinion, because of the wide array of
real hard problems related to so many different subjects of programming it has
to offer. Also, there are good chances it's quite different from what you
work on daily (a majority of programmers are knee deep in the web of mobile
applications these days) hence, will feel like a playful, new and exciting
project.

Now hold your horses as, **implementing a complete text editor that can rival
with you current one (even if it's _Notepad_ or _ed(1)_) is a really big task**.
Try to start by setting your eyes on implementing a subpart of a one first.

Now for ideas on sub-parts that you could aim for:

- **A line editor**: You know how your shell allows you to press backspace,
  delete characters to the beginning of the line, move the cursor? Well all of
  those are really nice thing but are quite novelties, most of there where not
  present in older shells. So, try your hand at implementing a program that asks
  for input but implements line editing features. Think of what a REPL does.
  Try for:
    - Typing characters
    - Backspace
    - Moving with arrows
    - Deleting to beginning/end of line
    - Moving to beginning/end of line
    - Moving word by word backward/forward
    - Entering in "replace mode" (like the `insert` key on keyboards)
- **Rendering a window tree of files**: Try writing a terminal program that
  renders a tree of windows, each node being one of three types: horizontal
  split, vertical split, actual file/window. That one will get you thinking
  about recursing in a tree, caching information about location in files,
  calculating what is a line, how wide is a char, a tab, a Unicode char, how
  do you make it fast enough so that render wouldn't block the editors main loop
  in a real editor. Try for:
    1. Reading files from disk
    1. Selecting a current position (so you get to implement scrolling)
    1. Creating a window tree so that all files have their own window split
    1. Rendering the window tree with nice window borders
    1. Framing and rendering the currently visible lines of the files
    1. Maybe have a status bar under each files showing stats line number of
      lines, current line, chars, file rights, file size, ....
    1. Make it fast by only rendering what's needed when some file changes on disk
- **A file datastructure**: Holding a file in memory, a task most editors need
  to do, is not an easy task. Getting it to be the right balance between:
  size in memory, insertion speed, deletion speed and interface complexity is a
  real struggle. The other problem you can attack after you have the basics
  right is testing operations on a file that is huge, bigger than 100MB and
  make that use case operations work in a decent time (< 100ms at least).
  Try exploring the following prior art in the matter:
    - [Rope](https://en.wikipedia.org/wiki/Rope_(data_structure))
    - [Gap Buffer](https://en.wikipedia.org/wiki/Gap_buffer)
    - [Circular buffer](https://en.wikipedia.org/wiki/Circular_buffer)
    - [Red-Black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree)
    - [or a simple Linked List](https://en.wikipedia.org/wiki/Linked_list)
    - [or try the venerable Array](https://en.wikipedia.org/wiki/Array_data_structure)<br>
  _Try testing how fast (and what's the Big O of each?) of the following
  operations:_
    - Inserting 1 character at the start/middle/end
    - Deleting 1 character at the start/middle/end
    - Inserting 10 000 characters at the start/middle/end
    - Deleting 10 000 characters at the start/middle/end
    - Inserting at the start the right after at the end
    - Loading in memory
    - Writing to disk
- **A command set/language**: This one is a fun one for language lovers as it
  involves implementing a set of commands the user can use to edit files.
  You need to be able to parse an input string into an abstract syntax tree,
  then interpret it and execute it against a file contents. Here are good
  examples of editors that implemented a command set:
  - Vi - covers a lot, succinct [[1]](http://vimdoc.sourceforge.net/htmldoc/usr_07.html)[[2]](http://vimdoc.sourceforge.net/htmldoc/usr_03.html)[[3]](http://vimdoc.sourceforge.net/htmldoc/usr_27.html)
  - Ed - not a visual editing, the grandfather of many others [1](http://www.gnu.org/software/ed/manual/ed_manual.html)
  - Teco - really a language, also inspired a few others [[1]](https://en.wikipedia.org/wiki/TECO_(text_editor)#Example_session)
  - Emacs - less on point but think about keyboard keybindings and how natural they are to hit [[1]](https://www.emacswiki.org/emacs/EmacsNewbieKeyReference)
- **A plugin/configuration language**: This one is all about implementing a
  full blown programming language (parser, interpreter, interface with host
  implementation language). A lot of toy editor project go without this one as
  it is a big chunk of work but a really crucial one in all popular editors
  theses day. You'll be designing a language with the direct goal of exposing
  editor features, configuration and allowing the implementation of plugins
  that can change behaviour and call core editor methods.
  Take a look at the following languages that are used in popular editors:
    - ELisp
    - VimL
    - Lua
    - Python
    - Guile Scheme
    - Perl
- **A progressive rendering algorithm**: This one is a bit smaller and needs
  quite a few pieces around it to make it work/visual. It consists in writing
  an algorithm that allows you to start a rerender of the screen following a
  user's input but allows for stopping in the middle to handle user input then
  start back for where we where at the last rerender call making sure to
  invalidate parts that where just changed by the user's action.
  Try reading this book at this point, it's really one of the only books going
  in deep about many subject related to text editor implementation:
    - [The Craft of Text Editing](https://www.finseth.com/craft/)

_There a more smaller projects/parts that could be added to this list but at
this point I would advise starting small but trying to build a complete editor
and adding adding is all of those subparts together._ **Those first big goal
being to be able to write the text editor with the new editor itself. :D**

If you are interested in reading the implementation of a few **toy editors**
with rather _simple codebases_ you can look at:

- [micro](https://github.com/zyedidia/micro)
- [godit](https://github.com/nsf/godit)
- [vis](https://github.com/martanne/vis)
- [liner](https://github.com/peterh/liner)
- [iota](https://github.com/gchp/iota)
- [wed](https://github.com/rgburke/wed)

Happy hacking & learning!
