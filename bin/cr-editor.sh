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

declare ret=1
echo "\ncr in progress... " >&2 
if test -n "${irebase_sha_to_reword:-}"; then
    tmpf="$(mktemp -d -p "$TMPDIR")/${1##*/}"
    echo "tmpfile: $tmpf"
    echo -n " editor: ${git_core_editor:-vi} "
    echo "and $(type ${git_core_editor:-vi})"
    if [ "${1##*/}" == "git-rebase-todo" ]; then
        echo "\ncr sedding in progress... " >&2 
        cp -af "$1" ${tmpf}
        sed -i "s,pick \(${irebase_sha_to_reword:0:7} .*\),r \\1," ${tmpf}
    elif [ "${1##*/}" == "COMMIT_EDITMSG" ]; then
        echo "\ncr editing in progress... " >&2 
        cp -af "$1" ${tmpf}
        ${git_core_editor:-vi} ${tmpf}
    fi
    if ! diff "$1" ${tmpf} >&3; then
        cp -af ${tmpf} "$1"
        ret=0
    fi
    if [ -n "${CRDEBUG}" ]; then
        echo "shaedit: ${irebase_sha_to_reword}"
        echo "tmpfile: ${tmpf}"
    else
        rm -f ${tmpf}
    fi
fi
exit $ret
