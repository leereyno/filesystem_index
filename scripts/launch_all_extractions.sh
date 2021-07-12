#!/bin/bash

if [ ! -d /root/tmp ] ; then
	mkdir -p /root/tmp
fi

CWD=$(pwd)

/bin/rm -f /root/tmp/scratchlist

cd /scratch

find -maxdepth 1 -type d 2>&1 | tail -n +2 | sort | sed -e 's/\.\///' > /root/tmp/scratchlist

cd $CWD

for each in $(cat /root/tmp/scratchlist) ; do

	echo $each

    screen -S "$each" -d -m ./extract_scratchdir.sh $each

	sleep 0.2

done

