#!/bin/bash

# Only run this on service-0-1

if [ $HOSTNAME != "service-0-1.asu.edu" ] ; then
	echo -e "\nThis script should be run on service-0-1\n"
	exit 1
fi

CHECKDATE="$(mysql -D beegfs_scratch_statistics -N -e 'select checkdate from statistics limit 1')"

./ownername_report.sh | tee /tmp/beegfs_ownername_report_${CHECKDATE}.csv
./rootdir_report.sh | tee /tmp/beegfs_rootdir_report_${CHECKDATE}.csv

dropbox_uploader.sh upload /tmp/beegfs_ownername_report_${CHECKDATE}.csv "/Business Intelligence Staff/beegfs_statistics/"
dropbox_uploader.sh upload /tmp/beegfs_rootdir_report_${CHECKDATE}.csv "/Business Intelligence Staff/beegfs_statistics/"

