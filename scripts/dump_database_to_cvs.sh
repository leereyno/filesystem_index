#!/bin/bash

QUERY="select * from statistics into outfile '/tmp/beegfs_scratch_statistics.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"

time /usr/bin/mysql -u root -h service-0-1 -p<SECRET> -D $MyDB -Be "$QUERY"
