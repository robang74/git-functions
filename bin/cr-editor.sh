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
echo "\ncr in progress... " >&2 
if test -n "${irebase_sha_to_reword:-}"; then
    tmpf=$(mktemp -p "$TMPDIR")
    if [ "${1##*/}" == "git-rebase-todo" ]; then
        echo "\ncr sedding in progress... " >&2 
        cp -af "$1" ${tmpf}
        sed -i "s,pick \(${irebase_sha_to_reword:0:7} .*\),r \\1," ${tmpf}
    elif [ "${1##*/}" == "COMMIT_EDITMSG" ]; then
        echo "\ncr editing in progress... " >&2 
        cp -af "$1" ${tmpf}
        vi ${tmpf}
    else
        rm -f ${tmpf}
        exit 1
    fi
    diff "$1" ${tmpf} | pipenull
    if [ ${PIPESTATUS} -ne 0 ]; then
        cp -af ${tmpf} "$1"
        rm -f ${tmpf}
        exit 0
    fi
    rm -f ${tmpf}
fi
exit 1
