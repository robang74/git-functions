#!/bin/bash
#
# Copyright (c) Roberto A. Foglietta, 2023
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#

source "$(dirname $0)/colors.shell"

trap 'echo -e "\n${ERROR} in line ${LINENO} occured, try again with set -x.\n"' ERR
set -eE

DESTDIR=".git-functions"
SRCNAME=$(readlink -f "$HOME/${DESTDIR}/git.functions")
GITREPO="https://github.com/robang74/git-functions.git"
SRCCMD="test -r ${SRCNAME} && source ${SRCNAME}"
THISCMD="$(basename $0)"
BRANCH="$(bcur)"
TOPDIR=${PWD}
cd

if [ "$1" == "uninstall" ]; then
    test ! -d "${DESTDIR}" && exit 0
    rm -rf "${DESTDIR}" && echo "\n${DONE}: uninstall\n"
    bashrc=$(grep -ve "source.*git.functions" .bashrc ||:)
    test -n "${bashrc}"
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
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "reinstall" -a -d "${DESTDIR}" ]; then
    cd "${TOPDIR}"
    bash ${THISCMD} uninstall
    cd
elif [ "$1" == "reinstall" -a ! -d "${DESTDIR}" ]; then
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "help" -o "x$1" == "x-h" ]; then
    echo "\n${USAGE}: ${THISCMD} [ uninstall | update | reinstall | help ]\n"
    exit 0
elif [ -n "$1" ]; then
    echo "\n${ERROR}: unrecognised '$1' option, try with help (-h)\n"
    trap - ERR
    exit 1
fi

git clone ${GITREPO} "${DESTDIR}"
if ! grep -- "${SRCCMD}" .bashrc 2>/dev/null; then
    echo "${SRCCMD}" >> .bashrc
fi

cd "${DESTDIR}"
bsw "${BRANCH}"

if which cc >/dev/null; then
    cc -c -fPIC isatty_override.c -o isatty_override.o
    cc isatty_override.o -shared -o isatty_override.so
    strip isatty_override.so 2>/dev/null || :
    echo
    echo -ne "${bicyan}Compiled${coloff}: "
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
eval "${SRCCMD}"
echo "For this bash, functions loaded via source ~/${DESTDIR}/git.functions"
echo
