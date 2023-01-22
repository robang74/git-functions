#!/bin/bash
#
# cr: commit-reword
#
# Copyright (c) Roberto A. Foglietta, 2022-2023
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#
#set -x

if [ ${GITSHLVL:-0} -lt 1 ]; then
    # RAF: restricted shell cannot redirect to file but it is fine
    #      to redirect to a open file descriptor towards /dev/null
    #      So, also exec could fail but in gitshell &3 is just open
    exec 3>/dev/null || return $?
fi

if [ -z "${irebase_sha_to_reword}" -a -n "$1" ]; then
    irebase_sha_to_reword=$1
    shift
fi
if [ -z "${irebase_sha_to_reword}" -o -z "$1" ]; then
    exit 1
fi

declare ret=1
echo -e "\ncr in progress... " >&2
tmpd="$(mktemp -d -p "$TMPDIR")"
tmpf="${tmpd}/${1##*/}"
echo "tmpfile: $tmpf"
echo -n "editor : ${git_core_editor:-vi} "
echo "and $(type ${git_core_editor:-vi})"
if [ "${1##*/}" == "git-rebase-todo" ]; then
    echo -e "\ncr sedding in progress... " >&2
    cp -af "$1" ${tmpf}
    sed -i "s,pick \(${irebase_sha_to_reword:0:7} .*\),r \\1," ${tmpf}
elif [ "${1##*/}" == "COMMIT_EDITMSG" ]; then
    echo -e "\ncr editing in progress... " >&2
    cp -af "$1" ${tmpf}
    ${git_core_editor:-vi} ${tmpf}
else
    echo -e "cr operation not supported, abort\n" >&2
    rm -rf ${tmpd}
    exit 1
fi
if ! diff "$1" ${tmpf} >&3; then
    cp -af ${tmpf} "$1"
    ret=0
fi
if [ -n "${CRDEBUG}" ]; then
    echo "shaedit: ${irebase_sha_to_reword}"
    echo "tmpfile: ${tmpf}"
else
    rm -rf ${tmpd}
fi
exit $ret
