#!/bin/bash
#
# Copyright (c) Roberto A. Foglietta, 2023
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#
#set -x

# RAF: restricted shell cannot redirect to file but it is fine
#      to redirect to a open file descriptor towards /dev/null
#      So, also exec could fail but in gitshell &3 is just open
exec 3>/dev/null

function exit() {
    trap -- ERR
    command exit ${1:-}
}

THISCMD="$(basename $0)"
trap 'echo -e "\n${ERROR:-ERROR} in '${THISCMD}' at line ${LINENO} occured, try again with set -x\n" >&2' ERR
set -e

TOPDIR=$(dirname $(readlink -f $0))
cd ${TOPDIR}

DESTDIR=".git-functions"
SRCNAME=$(readlink -fem "$HOME/${DESTDIR}/git.shell")
GITREPO="https://github.com/robang74/git-functions.git"
SRCCMD="unset -f gitshell; test -r ${SRCNAME} && GFRELOAD=1 source ${SRCNAME} >/dev/null"
BRANCH="$(git branch --show-current 2>&3 || echo main)"

if [ -z "${BRANCH}" ]; then
    echo -e "\n${ERROR:-ERROR}: branch not defined, abort.\n"
    exit 1
fi

function bashrc_clean() {
    local va vb
    va='source.*git.functions'
    vb='source.*git.shell'
    bashrc=$(grep -ve "$va" -e "$vb" ~/.bashrc ||:)
    test -n "${bashrc}" || return 0
    echo "${bashrc}" >~/.bashrc
}

function bashrc_setup() {
    if ! grep -qe "source.*${SRCNAME}" ~/.bashrc 2>&3; then
        echo "${SRCCMD}" >> ~/.bashrc
        tail -n1 ~/.bashrc | grep -qe "source.*${SRCNAME}"
        return $?
    fi
    return 0
}

cd
set -- "${1:-}"
if [ "$1" == "install" -o -z "$1" ]; then
    if [ -d "${DESTDIR}" ]; then
        echo -e "\n${NOTICE:-NOTICE}: folder ${DESTDIR} is present, use update\n"
        exit 1
    fi
elif [ "$1" == "uninstall" -o "$1" == "remove" ]; then
    bashrc_clean
    test ! -d "${DESTDIR}" && exit 0
    rm -rf "${DESTDIR}" && echo -e "\n${DONE:-DONE}: uninstall\n"
    exit $?
elif [ "$1" == "update" -a -d "${DESTDIR}" ]; then
    trap "echo -e '\n${ERROR:-ERROR}: install path ${PWD}\n'" EXIT
    set -e
    bashrc_clean
    bashrc_setup
    cd "${DESTDIR}"
    git switch ${BRANCH}
    git pull --rebase 
    eval "${SRCCMD}"
    echo -e "\n${DONE:-DONE}: install path ${PWD}\n"
    trap -- EXIT
    exit 0
elif [ "$1" == "update" -a ! -d "${DESTDIR}" ]; then
    echo -e "\n${NOTICE:-NOTICE}: folder ${DESTDIR} is not present, use install\n"
    exit 1
elif [ "$1" == "reinstall" -a -d "${DESTDIR}" ]; then
    eval "${TOPDIR}/${THISCMD} uninstall"
elif [ "$1" == "reinstall" -a ! -d "${DESTDIR}" ]; then
    echo -e "\n${NOTICE:-NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "help" -o "x$1" == "x-h" ]; then
    echo -e "\n${USAGE:-USAGE}: ${THISCMD} [ uninstall | update | reinstall | help ]\n"
    exit 0
elif [ -n "$1" ]; then
    echo -e "\n${ERROR:-ERROR}: unrecognised '$1' option, try with help (-h)\n"
    exit 1
elif [ -d "${DESTDIR}" ]; then
    echo -e "\n${ERROR:-ERROR}: folder ${TOPDIR}/${DESTDIR} exists, try with update or reinstall\n"
    exit 1
fi

git clone ${GITREPO} "${DESTDIR}"
cd "${DESTDIR}"
git switch "${BRANCH}"

if which cc >&3; then
    cc -c -fPIC isatty_override.c -o isatty_override.o
    cc isatty_override.o -shared -o isatty_override.so
    strip isatty_override.so 2>&3 || :
    echo
    echo -ne "${blcyn}Compiled${crst}: "
    du -b isatty_override.so
    rm -f isatty_override.o
elif [ "$(uname -m)" != "x86_64" ]; then
    echo -e "\n${WARNING}: need to install the compiler for isatty_override.so"
    rm -f isatty_override.so
else
    echo -e "\n${NOTICE:-NOTICE}: using the pre-compiled x86_64 isatty_override.so"
fi

bashrc_setup
echo -e "\n${DONE:-DONE}: git-functions installed in ${HOME}/${DESTDIR}\n"
echo -e "The git-function will be loaded by defaul via ~/.bashrc enviroment"
echo -e "For this bash, load functions via source ~/${DESTDIR}/$(basename ${SRCNAME})"
echo
