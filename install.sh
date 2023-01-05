#!/bin/bash
#
# Copyright (c) Roberto A. Foglietta, 2022
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#

DESTDIR=".git-functions"
SRCNAME="~/${DESTDIR}/git.functions"
SRCCMD="test -r \"${SRCNAME}\" && source \"${SRCNAME}\""
GITREPO="https://github.com/robang74/git-functions.git"
THISCMD="$(basename $0)"

set -e
source "$(dirname $0)/colors.shell"
trap 'echo -e "\n${ERROR} in line ${LINENO} occured, try again with set -x.\n"' ERR
cd $HONE

if [ "$1" == "uninstall" ]; then
    test ! -d "${DESTDIR}" && exit 0
    rm -rf "${DESTDIR}" && echo "\n${DONE}: uninstall\n"
    bashrc=$(grep -v -- "${SRCCMD}" .bashrc) 
    echo "$bashrc" >.bashrc
    exit $?
elif [ "$1" == "update" -a -d "${DESTDIR}" ]; then
    cd "${DESTDIR}" && git pull --rebase
    exit $?
elif [ "$1" == "update" -a ! -d "${DESTDIR}" ]; then
    echo "\n${NOTICE}: folder ${DESTDIR} is not present, installing...\n"
elif [ "$1" == "help" -o "x$1" == "x-h" ]; then
    echo "\n${USAGE}: ${THISCMD} [uninstall|update|help]\n"
    exit 0
elif [ -n "$1" ]; then
    echo "\n${ERROR}: unrecognised '$1' option, try with help (-h)\n"
    trap - ERR
    exit 1
fi

if [ -d "${DESTDIR}" ]; then
    echo "\n${ERROR}: $HOME/${DESTDIR} folder exists, use update\n"
    trap - ERR
    exit 1
fi

git clone ${GITREPO} "${DESTDIR}"
if ! grep -- "${SRCCMD}" .bashrc 2>/dev/null; then
    echo "${SRCCMD}" >> .bashrc
fi 
echo "\n${DONE}: git-functions installed in ${HOME}/${DESTDIR}\n"
echo "The git-function will be loaded into the next ~/.bashrc enviroment"
echo "For this bash load them with source ~/${DESTDIR}/git.functions"
echo
    
