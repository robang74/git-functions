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
* `gflist`: list the functions available
* `gfhelp`: like `gflist` but in a fancier way
* `gfupdate`: update the installation and reload the functions
* `gitshell`: spawns a restricted shell with the git-funtions enviroment
* `redef_git`: redefine the function `_git()` which is used internally
* `reset_git`: reset `_git()` to the default command `git`
* `egnc`: function alias for `egrep --color=never`
* `less`: function alias for `command less -Fr`
* `ugit`: unbuffered version of `git -P`

Example of `redef_git` and `reset_git` usage:

    redef_git -u # every functions of this wrapper will use `ugit` instead of `git`
    redef_git 'git -P "$@"'      # of this wrapper will use `git` with no pager
    reset_git    # every functions of this wrapper will use `git` as default

#### Configure functions

* `pcache`: set the password cache for 1h of inactivity, deal with `.gitpasswd`
* `editorset`: set your default editor

#### Operative functions

* `opst`: shows the current operation pending: merge, rebase or cherry-pick
* `todo`: short for `git --edit-todo`, arg: c,m,r or current operation
* `cont`: short for `git --continue`, arg: c,m,r or current operation
* `abrt`: short for `git --abort`, arg: c,m,r or current operation
* `skip`: short for `git --skip`, arg: c,m,r or current operation

#### Pure git functions which alter also the remote repository

* `push`: short for `git pull`
* `fpush`: short for `git push --force`
* `repshrink`: clean the reflog and shrink the repository
* `tagadd`: add a tag to a commit (sha as arg) and push tags
* `tagdel`: del a tag (as arg) and push the change

#### Pure git functions which alter the local repository, only

* `irebase`: rebase starting from the hash passed
* `pa`: format patch apply and create signed commit
* `ce`: commit edit within a restricted shell
* `am`, amend`: shorts for `git amend`
* `add`: short for `git add`
* `cm`: short for `git commit`
* `co`: short for `git checkout`
* `pull`: short for `git pull`
* `rpull`: short for `git pull --rebase`
* `rcont`: short for `git rebase --continue`
* `forig`: short for `git fetch origin`
* `stash`: short for `git stash`
* `pop`: short for `git stash pop`
* `chpk`: short for `git cherry-pick`

#### Pure git functions which do NOT alter the repositories
 
* `lg`: show the log in a compact and fancy way, SHAs or files as args
* `lt`: like `lg` but with all branches shown, files as args
* `lg1`: like `lg` but just the first line
* `rl`, `reflog`: shorts for `git reflog`
* `sw`: short for `git show`, opt:-P for no pager
* `ff`: short for `git diff`, opts -s:staged -s:origin
* `sf`: show the file involved in a commit, SHAs as args
* `lgrp`: find a string into the `lg` output, opt -s:SHAs-only
* `fpatch`: do a `git format-patch` for the commit, SHA and opts in arg
* `bsw`: short for `git switch`, the branch name as arg or `-` for the last
* `hcur`: short for `git rev-parse --short HEAD`
* `bcur`: short for `git branch --show-current`
* `lsbr`: show the list of remote branches
* `tagl`: short for `git tag -l`
* `st`: short for `git status`

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

In case the last command fails then the loop stops and spawn a emergency `bash`
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

    ./install.sh [ uninstall | update | reinstall | help ]

then follow the instructions, in particular source the `git.fuctions` in your
current bash environment. To install the development version switch the branch
with `git switch devel` and the run the installer from that branch.


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


isatty() override
-----------------

To improve dramatically the fancy coloured output combined with some features
like grepping and lessing, it has been used the trick to override `isatty()`
using a small piece of code `isatty_override.c` which produces `.so` library:

    LD_PRELOAD="${path}/isatty_override.so" git -P "$@"

This is an example of usage which resembles the core of the 'ugit' function.


License
-------

The copyright notice, the license and the author is reported in each file
header, here summarised:

* `colors.shell`: MIT
* `isatty_override.c`: MIT
* `git-commit-edit`: public domain
* `git-isar-send-patch`: GPLv3
* `git.functions`: GPLv3
* `install.sh`: GPLv3


Author
------

* Roberto A. Foglietta <roberto.foglietta@gmail.com>

