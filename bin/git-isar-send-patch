#!/bin/bash
#
# Copyright (c) Roberto A. Foglietta, 2022-2023
#
# Authors:
#  Roberto A. Foglietta <roberto.foglietta@gmail.com>
#
# SPDX-License-Identifier: GPLv3
#

echo
set -eE
if [ "$2" == "" -a -f "$1" ]; then
	echo "Retrieving subject from the patch ..."
	echo
	subject=$(grep Subject: "$1" | head -n1 | cut -d: -f2 | cut -d' ' -f2-)
	patch=$1
else
	subject=$1
	patch=$2
fi
declare -i n=$(grep -n Signed-off-by "$patch" | cut -d: -f1)
if [ $n -eq 0 ]; then
    echo "ERROR: patch is not signed, abort!"
    echo
    exit 1
elif [ $n -le 7 ]; then
    echo "WARNING: patch description is missing, using subject ..."
    desc=$(head -n5 "$patch" | tail -n2 | grep . | cut -d\] -f2- | tr -d '\n' | fold -w 80 -);
    text=$(head -n5 "$patch" | egrep . ; echo; echo -e $desc; tac "$patch" | head -n-$[n-2] | tac -)
    echo "$text" >"$patch"
    echo
fi
usermail=$(git config user.email)
fromuser=$(git config sendemail.from)
destination=isar-users@googlegroups.com
test -n "$usermail" -a -n "$subject" -a -n "$patch"
shift
set -x
git send-email --from $fromuser --to $destination --cc $usermail --subject "$subject" "$patch"
