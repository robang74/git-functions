#!/bin/bash
#set -x
set -e

c=0
test -e "$1"
for i in 1 $(grep -n ^diff "$1" | cut -d: -f1) $(wc -l "$1" | cut -d' ' -f1); do
	if [ -z "$a" ]; then a=$i; continue; fi
	b=$i; head -n$[b-1] "$1" | tail -n$[b-a] >$c.patch; a=$b; let c++||:
done

(
    a=$(grep -n "Subject: " 0.patch | cut -d: -f1)
    b=$(grep -n "Date: " 0.patch | cut -d: -f1)
    head -n$[b-1] 0.patch | tail -n$[b-a]
    echo

    a=$(grep -vn . 0.patch | head -n1 | cut -d: -f1)
    b=$(wc -l 0.patch | cut -d' ' -f1)
    head -n$b 0.patch | tail -n$[b-a]
) > cm.msg

sed -i -e "1s,^Subject: .PATCH [^]]*. ,," -e "1s,^Subject: .PATCH ,," cm.msg
msg=$(cat cm.msg); echo -e "\n$msg\n"
a=$(grep -n -- "^---$" cm.msg  | cut -d: -f1)
echo "$msg" | head -n$[a-1] > cm.msg

