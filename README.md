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
* `no-opts`: print every arg that does not start with minus
* `gfupdate`: update the installation and reload the functions
* `gitshell`: spawns a restricted shell with the git-funtions enviroment
* `pipenull`: `cmd | pipenull` instead of `cmd >/dev/null`, use ${PIPESTATUS[@]}
* `cdtop`: change directory to the top level of the repository and prints the full path
* `redef_git`: redefine the function `_git()` which is used internally
* `reset_git`: reset `_git()` to the default command `git`
* `egnc`: function alias for `egrep --color=never`
* `less`: function alias for `command less -Fr`
* `ps1p`: print a custom PS1 for git users
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
* `cont`: short for `git --continue`, arg: c,m,r,ce or current operation
* `abrt`: short for `git --abort`, arg: c,m,r,ce or current operation
* `skip`: short for `git --skip`, arg: c,m,r or current operation

#### Pure git functions which alter also the remote repository

* `push`: short for `git pull`
* `fpush`: short for `git push --force`
* `repshrink`: clean the reflog and shrink the repository
* `tagadd`: add a tag to a commit (sha as arg) and push tags
* `tagdel`: del a tag (as arg) and push the change
* `rmt`: short for `git remote`

#### Pure git functions which alter the local repository, only

* `forig`: short for `git fetch origin`
* `frmt`: short for `git fetch`, default the first in `lsrmt` or args with opt -a:--all
* `search`: search for a string in all the commits and report the first found, arg string
* `irb`, `irebase`: rebase starting from the hash passed or ~n, -n for `HEAD~n`
* `pa`: format patch apply and create signed commit
* `ce`: commit edit within a restricted shell
* `cr`: commit reword, a single SHA as arg
* `am`, amend`: shorts for `git amend`
* `add`: short for `git add`
* `cm`: short for `git commit`
* `co`: short for `git checkout`
* `pull`: short for `git pull`
* `rpull`: short for `git pull --rebase`
* `rcont`: short for `git rebase --continue`
* `stash`: short for `git stash`
* `pop`: short for `git stash pop`
* `chpk`: short for `git cherry-pick`
* `rst()`: short for `git reset`, opt -h:--hard
* `res()`: short for `git restore`, opt -S:--staged
* `hrst()`: short for `git reset --hard`, opt -r:remote
* `sres()`: short for `git restore i--staged`
* `tres()`: total restore res -S and res, both

#### Pure git functions which do NOT alter the repositories
 
* `lg`: show the log in a compact and fancy way, SHAs or files as args
* `lgnc`: the same of `lg` but without colors, for scripting
* `lgrp`: find a string into the `lg` output, opt -s:SHAs-only
* `lgrpnc`: the same of `lgrp` but without colors, for scriptings
* `lt`: like `lg` but with all branches shown, files as args
* `lg1`: like `lg` but just the first line
* `rl`, `reflog`: shorts for `git reflog`
* `ff`: short for `git diff`, opts -s:staged -o:origin
* `sf`: show the file involved in a commit, SHAs as args
* `sw`: short for `git show` with `sf` after, opt:-P for no pager
* `fpatch`: do a `git format-patch` for the commit, SHA and opts in arg
* `bsw`: short for `git switch`, the branch name as arg or `-` for the last
* `rcur`: remote branch which the current s tracking
* `hcur`: short for `git rev-parse --short HEAD`
* `bcur`: short for `git branch --show-current`
* `lsrmt`: shoe the list of remotes sources
* `lsbr`: show the list of remote branches
* `lstag`, `tagl`: shorts for `git tag -l`
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
  * -f: fetch all the remotes before starting

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

Almost all the files are under MIT license or GPLv3 and the others are in the
public domain. However the composition of these files is protected by the GPLv3
license.

This means that everyone can use a single MIT licensed file or a part of it
under the MIT license terms. Instead, using two of them or two parts of them
implies that you are using a subset of this collection. Thus a derived work of
this collection which is licensed under the GPLv3 also.

The GPLv3 license applies to the composition unless you are the original
copyright owner or the author of a specific unmodified file. This means that
every one that can legally claim rights about the original files maintains its
rights, obviously. So, it should not need to complain with the GPLv3 license
applied to the composition. Unless, the composition is adopted for the part
which had not the rights, before.

The copyright notice, the license and the author is reported in each file
header, here summarised:

* `colors.shell`: MIT
* `isatty_override.c`: MIT
* `git-commit-edit`: public domain
* `git-isar-send-patch`: GPLv3
* `git.functions`: GPLv3
* `cr-editor.sh`: GPLv3
* `install.sh`: GPLv3


Author
------

* Roberto A. Foglietta <roberto.foglietta@gmail.com>

