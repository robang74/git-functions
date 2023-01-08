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
    if [ "${1##*/}" == "git-rebase-todo" ]; then
        echo "\ncr sedding in progress... " >&2 
        cp -arf "$1" /tmp/cr
        sed -i "s,pick \(${irebase_sha_to_reword} .*\),r \\1," /tmp/cr
    elif [ "${1##*/}" == "COMMIT_EDITMSG" ]; then
        echo "\ncr editing in progress... " >&2 
        cp -arf "$1" /tmp/cr
        vi /tmp/cr
    fi
fi
diff "$1" /tmp/cr | pipenull
if [ ${PIPESTATUS} -ne 0 ]; then
    cat /tmp/cr >"$1"
    exit $?
fi
#abrt
exit 1
