# git-functions
source the git.functions to improve the git users experience in your bash

List of the functions
---------------------

Service functions:

* gfreload: reload the functions
* gfupdate: update the installation of the git-functions and reload them
* gflist: list the functions available
* gfhelp: like gflist but in a fancy way

Configure functions:

* ccache: set the password cache for 1h of inactivity, deal with .gitpasswd
* editorset: set your default editor

Pure git functions which alter also the remote repository:

* push: short for git pull
* fpush: short for git push --force
* repshrink: clean the reflog and shrink the repository
* tagdel
* tagadd

Pure git functions which alter the local repository:

* irebase: rebase starting from the hash passed
* add: short for git add
* cm: short for git commit
* amend: short for git amend
* rpull: short for git pull --rebase
* co: short for git checkout
* forig: short for git fetch origin
* rcont: short for git rebase --continue
* stash: short for git stash
* pop: short for git stash pop
* pull: short for git pull
* chpk: short for git cherry-pick

Pure git functions which do NOT alter the local nor the remote repositories:
 
* lg: show the log in a compact and fancy way
* lt: like lg but with all branches shown
* st: short for git status
* ff: short for git diff
* rl: short for git reflog
* sw: short for git show
* fpatch: git format patch for the commit, sha in arg
* lsbr: show the list of remote branches
* bsw: short for git switch $branch, branch name in arg
* for-all-other-branches: execute the args for every branch
* lgrp: find a string into the lg output

Usage
-----

    source git.functions # just to try

Installation
------------

    ./install.sh [ uninstall | update | help ]

License
-------

The copyright notice, the lincese and the author is reported in each file header, here summarised:

* colors.shell: MIT
* git.functions: GPLv3
* install.sh: GPLv3

Author
------

* Roberto A. Foglietta <roberto.foglietta@gmail.com>

