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

THISCMD="$(basename $0)"
trap 'echo -e "\n'${ERROR:-ERROR}' in '${THISCMD}' at line ${LINENO} occured, try again with set -x\n"' ERR
set -eE

TOPDIR=$(dirname $(readlink -f $0))
source "${TOPDIR}/git.functions"
cd ${TOPDIR}

DESTDIR=".git-functions"
SRCNAME=$(readlink -fem "$HOME/${DESTDIR}/git.functions")
GITREPO="https://github.com/robang74/git-functions.git"
SRCCMD="test -r ${SRCNAME} && source ${SRCNAME}"
BRANCH="$(bcur)"

if [ -z "${BRANCH}" ]; then
    echo "\n${ERROR}: branch not defined, abort.\n"
    exit 1
fi

cd
set -- "${1:-}"
if [ "$1" == "install" -o -z "$1" ]; then
    if [ -d "${DESTDIR}" ]; then
        echo "\n${NOTICE}: folder ${DESTDIR} is present, use update\n"
        exit 1
    fi
elif [ "$1" == "uninstall" ]; then
    test ! -d "${DESTDIR}" && exit 0
    rm -rf "${DESTDIR}" && echo "\n${DONE}: uninstall\n"
    bashrc=$(grep -ve "source.*git.functions" .bashrc ||:)
    test -n "${bashrc}" || exit 0
    echo "${bashrc}" >.bashrc
    exit $?
elif [ "$1" == "update" -a -d "${DESTDIR}" ]; then
    ret=0
    op="${ERROR}"
    cd "${DESTDIR}" && bsw ${BRANCH} && rpull && op="${DONE}" || ret=1
    echo -e "\n$op: install path ${PWD}\n"
    eval ${SRCCMD} || ret=1
    exit $ret
elif [ "$1" == "update" -a ! -d "${DESTDIR}" ]; then
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, use install\n"
    exit 1
elif [ "$1" == "reinstall" -a -d "${DESTDIR}" ]; then
    eval "${TOPDIR}/${THISCMD} uninstall"
elif [ "$1" == "reinstall" -a ! -d "${DESTDIR}" ]; then
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "help" -o "x$1" == "x-h" ]; then
    echo -e "\n${USAGE}: ${THISCMD} [ uninstall | update | reinstall | help ]\n"
    exit 0
elif [ -d "${DESTDIR}" ]; then
    echo -e "\n${ERROR}: folder ${TOPDIR}/${DESTDIR} exists, try with update or reinstall\n"
    exit 1
elif [ -n "$1" ]; then
    echo "\n${ERROR}: unrecognised '$1' option, try with help (-h)\n"
    trap - ERR
    exit 1
fi

git clone ${GITREPO} "${DESTDIR}"
if ! grep -- "${SRCCMD}" .bashrc 2>&3; then
    echo "${SRCCMD}" >> .bashrc
fi

cd "${DESTDIR}"
bsw "${BRANCH}"

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
    echo -e "\n${NOTICE}: using the pre-compiled x86_64 isatty_override.so"
fi

echo "\n${DONE}: git-functions installed in ${HOME}/${DESTDIR}\n"
echo "The git-function will be loaded by defaul vi ~/.bashrc enviroment"
echo "For this bash, load functions via source ~/${DESTDIR}/git.functions"
echo
