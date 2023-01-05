# git-functions

source the `git.functions` to improve the git users experience in your bash


List of the functions
---------------------

Service functions:

* `gfreload`: reload the functions
* `gfupdate`: update the installation and reload the functions
* `gflist`: list the functions available
* `gfhelp`: like `gflist` but in a fancier way

Configure functions:

* `pcache`: set the password cache for 1h of inactivity, deal with `.gitpasswd`
* `editorset`: set your default editor

Pure git functions which alter also the remote repository:

* `push`: short for `git pull`
* `fpush`: short for `git push --force`
* `repshrink`: clean the reflog and shrink the repository
* `tagadd`: add a tag to a commit (sha as arg) and push tags
* `tagdel`: del a tag (as arg) and push the change

Pure git functions which alter the local repository:

* `irebase`: rebase starting from the hash passed
* `add`: short for `git add`
* `cm`: short for `git commit`
* `amend`: short for `git amend`
* `rpull`: short for `git pull --rebase`
* `co`: short for `git checkout`
* `forig`: short for `git fetch origin`
* `rcont`: short for `git rebase --continue`
* `stash`: short for `git stash`
* `pop`: short for `git stash pop`
* `pull`: short for `git pull`
* `chpk`: short for `git cherry-pick`

Pure git functions which do NOT alter the local nor the remote repositories:
 
* `lg`: show the log in a compact and fancy way
* `lt`: like lg but with all branches shown
* `st`: short for `git status`
* `ff`: short for `git diff`
* `rl`: short for `git reflog`
* `sw`: short for `git show`
* `fpatch`: do a `git format-patch` for the commit, sha in arg
* `lsbr`: show the list of remote branches
* `bsw`: short for `git switch`, the branch name as arg
* `for-all-other-branches`: execute the args as commands for every branch
* `lgrp`: find a string into the `lg` output


Usage
-----

Just to give it a try, source the `git.functions` in your environment and call
them in your git local repository

    source git.functions

this file also source the `colors.shell` in order to produce a color full
output  


Installation
------------

To install in your system in a way they will be loaded by `~/.bashrc` use this
script without any argument

    ./install.sh [ uninstall | update | help ]

then follow the instructions, in particular source the `git.fuctions` in your
current bash environment


Password cache
--------------

The use of the password cache function `pcache` could undermine your git remote
repository security especially if used in combination with `.gitpasswd`.
Moreover the use of the password cache or saving your git password in plain
text in a file of your workstation disk could go against your company security
policies. For extra security you can disable this function with

    unset pcache

You might also want to add after the source `git.function` in your `~/.bashrc`
to make this choice as the default one.


License
-------

The copyright notice, the license and the author is reported in each file
header, here summarised:

* `colors.shell`: MIT
* `git.functions`: GPLv3
* `install.sh`: GPLv3


Author
------

* Roberto A. Foglietta <roberto.foglietta@gmail.com>

