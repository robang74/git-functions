# git-functions

source the `git.functions` to improve the git users experience in your bash


Rationale
---------

Every comfortable command-line UI should be verbose enough to be descriptive
and self-explanatory and IMHO `git` achieved this goal very well. However, for
an intensive use - after having learned the command-line UI - verbosity impairs
productivity and there is no way to avoid writing `git` in front of every 
command unless a functions-set wrap layer is used. This is the point in which
`git-functions` arrives and aim to help those whose hands wish to be faster
than their minds. Have fun <3


List of the functions
---------------------

The following list is divided for class of usage and roles

#### Service functions

* `gfreload`: reload the functions
* `gfupdate`: update the installation and reload the functions
* `gflist`: list the functions available
* `gfhelp`: like `gflist` but in a fancier way

#### Configure functions

* `pcache`: set the password cache for 1h of inactivity, deal with `.gitpasswd`
* `editorset`: set your default editor

#### Pure git functions which alter also the remote repository

* `push`: short for `git pull`
* `fpush`: short for `git push --force`
* `repshrink`: clean the reflog and shrink the repository
* `tagadd`: add a tag to a commit (sha as arg) and push tags
* `tagdel`: del a tag (as arg) and push the change

#### Pure git functions which alter the local repository

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

#### Pure git functions which do NOT alter the repositories
 
* `lg`: show the log in a compact and fancy way, SHAs or files as args
* `lt`: like lg but with all branches shown, files as args
* `st`: short for `git status`
* `ff`: short for `git diff`
* `rl`: short for `git reflog`
* `sw`: short for `git show`
* `fpatch`: do a `git format-patch` for the commit, SHA and opts in arg
* `lsbr`: show the list of remote branches
* `bsw`: short for `git switch`, the branch name as arg
* `lgrp`: find a string into the `lg` output
* `bcur`: short for `git branch --show-current`
* `hcur`: short for `git rev-parse --short HEAD`

#### Command execution on multiple branches

This is a special function used to execute commands (cmds) on multiple branches:

* `for-all-other-branches`: execute the args as commands for the branches
  * --: per default runs over all the branches but not the current one
  * -a: all the branches included the current
  * -p: `git pull` before cmds
  * -r: `git pull --rebase` before cmds
  * -s: `git stash` before go and `git stash pop` when returns
  * -n: not fail despite the last command failure

A custom branches selction could be specified in this way:

    BRANCHES="uno due tre" for-all-other-branches 'cmds ${branch}'

The `branch` variable is defined in the loop and its value is the branch name
on which commands are currently executing. The single quotes around the
commands string are necessary to avoid that the variable is expanded before
starting the loop.

In case the last command fails then the loop stops and spwan a emergency `bash`
in that shell - which is restricted - the operator can handle the issue and
then decide to proceed further with `exit` or definitely stop with `exit 1`.

    Switched to branch 'devel'
    Your branch is up-to-date with 'origin/devel'.

    branch: devel, KO
    fix the problem and then enter 'exit'
    or enter 'exit 1' to abort completely

    +git:devel> exit 1


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
to make this choice as the default one. However, `gfreload` and `gfupdate` will
load again into your current bash environment. To avoid this risk, then use:

    unset pcache gfreload gfupdate

So, no one of these functions will be able to interfere with your security
policy but you will need to use `install.sh update` to update your
git-functions installation.


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

