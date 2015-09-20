+++
title = "Have you heard of editor religious wars?"
date = "2014-12-01"
slug = "changing-religion"
+++

I the domain of text editors people have strong feelings. Your choice of editor always was source of judgment by others, sign of superiority or inferiority or leading to strong debates about the best editor.

Few days ago I started musing with the enemy camp: Emacs. I have been truthful to the Vim church for now almost a year (at my young age that's a lot) and it has been truly enlightening. But, there's always a but, it has some quicks, some little tiny irritants (to name two: lack of good async command running, VimL)

You wish for a verdict right, a third of you wish I'd say the experience was horrible and that I will never sin again, the other is like "Yes, yes! Juuuust try it, for few days, you'll fall in love" and an other third is still wondering what those two editors have that makes them so special.

Ok here it goes: Emacs is glorious, it really lives up to the classic Vimmers joke "it's a nice operating system missing a decent text editor", but I find the "decent text editor" part not to be lacking so much. Yes, out of the box you don't have a _bazillion_ key maps for editing, but hey adding them using clean and simple lisp will be a joy right?

Although I could go through all the technical details and talk to you about each and every line that I added to my _emacs_ config, I won't, I will leave you the pleasure to scan through them open up the help (`C-h f`) or google search. Instead I will list few pros and cons I have encountered.

Here lies the results of my explorations: [https://github.com/kiasaki/dotfiles/tree/master/emacs.d](https://github.com/kiasaki/dotfiles/tree/master/emacs.d)

## Pros

- EmacsLisp
- Central package repository
- Apps, like fully functional everyday use apps (Org mode, Erc, Magit, ...)
- Package manager works great
- Out-of-the-box stuff
- Less hard to get used to than Vim modal editing
- Async tasks like your test suite running in bg
- Great shell integration with 3 option all having nice pros and cons (eshell, shell, term)

## Cons

- Window management is wonky and I never feel in control of what pops up where
- 2-3 if not 5 key presses for every command and all in one corner of the keyboard, Vim is really good at making you fast by allowing you to map any keyboard key
- You end up configuring a lot more, I quickly outgrown the 1 file config set and separated to multiple files
- This is minor one but startup up is not instant / lightning fast, at least not without an emacs server

**Conclusion**, after coming back to work on Monday and actually try to edit efficiently in a codebase instead of simply explore an operating system called Emacs, I quickly closed it, fired up my trusty perfectly configured Vim and got back up to speed. No, I didn't change religion. But, I am happy that I tried it out, I can tell what is Emacs and how it's different, not simply hate with no valid reason.
