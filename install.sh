#!/bin/bash
#
# Copyright (c) Roberto A. Foglietta, 2023
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#

DESTDIR=".git-functions"
SRCNAME="~/${DESTDIR}/git.functions"
SRCCMD="test -r ${SRCNAME} && source ${SRCNAME}"
GITREPO="https://github.com/robang74/git-functions.git"
THISCMD="$(basename $0)"

set -e
TOPDIR=${PWD}
source "$(dirname $0)/colors.shell"
trap 'echo -e "\n${ERROR} in line ${LINENO} occured, try again with set -x.\n"' ERR
BRANCH="$(bcur)"
cd

if [ "$1" == "uninstall" ]; then
    test ! -d "${DESTDIR}" && exit 0
    rm -rf "${DESTDIR}" && echo "\n${DONE}: uninstall\n"
    bashrc=$(grep -v -- "${SRCCMD}" .bashrc)
    echo "$bashrc" >.bashrc
    exit $?
elif [ "$1" == "update" -a -d "${DESTDIR}" ]; then
    cd "${DESTDIR}" && bsw ${BRANCH} && rpull
    exit $?
elif [ "$1" == "update" -a ! -d "${DESTDIR}" ]; then
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "reinstall" -a -d "${DESTDIR}" ]; then
    set -e
    cd "${TOPDIR}"
    eval "./${THISCMD}" uninstall
    cd
    set +e
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
echo "The git-function will be loaded into the next ~/.bashrc enviroment"
echo "For this bash load them with source ~/${DESTDIR}/git.functions"
echo
