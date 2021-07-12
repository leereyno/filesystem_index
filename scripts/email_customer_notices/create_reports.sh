#!/bin/bash

CHECKDATE="2020-09-01"

for each in $(cat customerlist | grep -v '#') ; do

	echo $each

	/bin/rm -f /tmp/$each

	LESSQUERY="select lastaccess,rootdir,path from statistics where ownername='$each' and lastaccess <= DATE_SUB('$CHECKDATE', INTERVAL 120 DAY) into outfile '/tmp/$each'"
	#GREATERQUERY="select lastaccess,lastmodify,rootdir,path from statistics where ownername='$each' and lastaccess >= DATE_SUB('$CHECKDATE', INTERVAL 120 DAY) limit 10"

	time mysql -h service-0-1 -u root -p<SECRET> -D beegfs_scratch_statistics -N -Be "$LESSQUERY" 

	#time mysql -h service-0-1 -u root -p<SECRET> -D beegfs_scratch_statistics -N -Be "$LESSQUERY" > reports/${each} 2>/dev/null
	#time mysql -h service-0-1 -u root -p<SECRET> -D beegfs_scratch_statistics -N -Be "$LESSQUERY" > reports/less_${each} 2>/dev/null
	#time mysql -h service-0-1 -u root -p<SECRET> -D beegfs_scratch_statistics -N -Be "$GREATERQUERY" > reports/greater_${each} 2>/dev/null

	mv /tmp/$each reports/

done
