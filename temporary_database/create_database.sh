#!/bin/bash

if [ $HOSTNAME != "service-0-1.asu.edu" ] ; then
	echo -e "\nThis script should be run on service-0-1\n"
	exit 1
fi

mysql < beegfs_scratch_statistics.sql

mysql < views.sql
