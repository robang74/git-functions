# git-functions

source the `git.functions` to improve the git users experience in your bash


Rationale
---------

Every comfortable command-line UI should be verbose enough to be descriptive
and self-explanatory and IMHO `git` achieved this goal very well. However, for
intensive use - after having learned the command-line UI - verbosity impairs
productivity and there is no way to avoid writing `git` in front of every
command unless a functions-set wrap layer is used. This is the point in which
`git-functions` arrives and aims to help those whose hands wish to be faster
than their minds.

Have fun <3


About using the bash
--------------------

The `dash` which is the standard by default shell in GNU/Debian Linux is about
2x faster than `bash` to execute commands and probably `bash` is the slowest
shell of all. However, bashism are somewhat powerful shell-scripting tricks and
moreover, the user interaction with small functions does not require any
particular performance to be acceptable and in any case `git` is the real
bottle-neck in performances especially when it queries a remote host.


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
with `git switch devel` and then run the installer from that branch.

Alternatively, you can do a remote installation with these commands

    branch=main
    repo=https://raw.githubusercontent.com/robang74/git-functions
    wget $repo/$branch/install.sh -O - | bash

You might want to change the branch in `devel` but that branch, from time to
time, could be totally broken. Other branches might have the same problem.
However, also for the `main` branch, it is not assured of the lack of bugs.


Usage
-----

After installation your `.bashrc` will be modified in such a way the `gitshell`
will be defined as a function. Calling it - in your git repository - will give
you the access to the wrap layer:

    cd my-repo.git
    gitshell
    gfhelp

This command will display the functions available which are reported and
briefly described here below. If you need more functions, feel free to add to
the source code and share the change with the author. Or ask for an addition.


API changes
-----------

* `lsrmt`: was a replica of `rmt` now is a short for `rmt -v`
* `ff`, `sw`: in git use -w (ignore blank spaces) as default
* `gfreload`: opt:-f added to reload a single function


List of the functions
---------------------

The following list is divided for class of usage and roles:

#### Service functions

* `gfreload`: reload the functions
* `gflist`: list the functions available
* `gfhelp`: like `gflist` but in a fancier way
* `no-opts`: print every arg that does not start with minus
* `gfupdate`: update the installation and reload the functions
* `gitshell`: spawns a restricted shell with the git-funtions enviroment
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

#### Functions which alter also the remote repository

* `push`: short for `git pull`
* `fpush`: short for `git push --force`
* `repshrink`: clean the reflog and shrink the repository
* `tagmv`: move a tag to hash (as args) and push the changes
* `tagadd`: add a tag to a commit (sha as arg) and push tags
* `tagdel`: del a tag (as arg) and push the change
* `rmtadd`: add a remote repository to the local
* `rmtdel`: delete a remote repository
* `rmt`: short for `git remote`

#### Functions which alter the local repository, only

* `forig`: short for `git fetch origin`
* `frmt`: short for `git fetch`, default the first in `lsrmt` or args with opt -a:--all
* `search`: search for a string in all the commits and report the first found, arg string
* `irb`, `irebase`: rebase starting from the hash passed or ~n, -n for `HEAD~n`
* `pa`: format patch apply and create signed commit
* `ce`: commit edit within a restricted shell
* `cr`: commit reword, a single SHA as arg
* `amd`, amend`: shorts for `git amend`
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
* `ampatch()`: short for `git amend` a patch/set

#### Functions which do NOT alter the repositories
 
* `hconv`: convert the hash reference into a standard 7-chars hash
* `lg`: show the log in a compact and fancy way, SHAs or files as args
* `lgnc`: the same of `lg` but without colors, for scripting
* `lgrpnc`: the same of `lgrp` but without colors, for scriptings
* `lt`: like `lg` but with all branches shown, files as args
* `lg1`: like `lg` but just the first line
* `rl`, `reflog`: shorts for `git reflog`
* `ff`: short for `git diff`, opts -s:staged -o:origin
* `sf`: show the file involved in a commit, SHAs as args
* `sw`: short for `git show` with `sf` after, opt:-P for no pager
* `fpatch`: do a `git format-patch` for the commit, SHA and opts in arg
* `bsw`: short for `git switch`, the branch name as arg or `-` for the last
* `lgrp`: find a string into the `lg` output, opts -s:SHAs-only -1:first only
* `lsbr`: show the list of branches, arg branch name, opt: -r:remotes, -a:all
* `rbcur`: remote branch which the current brach is tracking
* `rcur`: remote origin which the current branch is tracking
* `hcur`: short for `git rev-parse --short HEAD`
* `bcur`: short for `git branch --show-current`
* `lsrmt`: shoe the list of remotes sources
* `lstag`, `tagl`: shorts for `git tag -l`
* `st`: short for `git status`

#### Command execution on multiple branches

This is a special function used to execute commands (cmds) on multiple branches:

* `for-all-other-branches`: execute the args as commands for the branches
  * `--`: per default runs over all the branches but not the current one
  * `-a`: all the branches included the current
  * `-p`: `git pull` before cmds
  * `-r`: `git pull --rebase` before cmds
  * `-n`: not fail despite the last command failure
  * `-s`: `git stash` before go and `git stash pop` when returns
  * `-f`: fetch all the remotes before starting otherwise run only on locals

A custom branches selction could be specified in this way:

    BRANCHES="uno due tre" for-all-other-branches 'cmds ${branch}'

The `branch` variable is defined in the loop and its value is the branch name
on which commands are currently executing. The single quotes around the
commands string are necessary to avoid that the variable is expanded before
starting the loop.

In case the last command fails then the loop stops and spawns an emergency `bash`
in that shell - which is restricted - the operator can handle the issue and
then decide to proceed further with `exit` or definitely stop with `exit 1`.

    Switch to branch 'devel'
    Your branch is up-to-date with 'origin/devel'.

    branch: devel, KO
    fix the problem and then enter 'exit'
    or enter 'exit 1' to abort completely

    +git:devel> exit 1


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
public domain. Instead, the composition of these files is protected by the GPLv3
license.

* [Copyright Act, title 17. U.S.C. § 101.](https://www.law.cornell.edu/uscode/text/17/101)

    Under the Copyright Act, a compilation [NDR: "composition" is used here as
    synonym because compilation might confuse the reader about code compiling]
    is defined as a "collection and assembling of preexisting materials or of
    data [NDR: source code, as well] that are selected in such a way that the
    resulting work as a whole constitutes an original work of authorship."

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

