#!/bin/bash

# %n	Name
# %F	File type
# %u	UID
# %g	GID
# %U	User name
# %G	Group name
# %s	Size in bytes
# %x	Time of last access
# %y	Time of last change
# %z	Time of last modify

MyUSER="root"                    # USERNAME                                     
MyPASS="<SECRET>"                 # PASSWORD                                        
MyHOST="service-0-1"            # Hostname                                      
MyDB="beegfs_scratch_statistics"         # Database to use                      
MYSQL="$(which mysql)"          # Path to mysql                                 
                                                                                
MyConn="$MYSQL --local-infile=1 -u $MyUSER -h $MyHOST -p$MyPASS -D $MyDB -Be"                    

IFS=$(echo -en "\n\b")

PATH=/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/packages/sysadmin/agave/scripts/:/packages/7x/perl5lib/bin:/opt/puppetlabs/bin:/root/bin

#WORKINGDIR="/packages/7x/sysadmin/scratch_monitor/beegfs_scratch_statistics"
WORKINGDIR="/root/"

for each in $(/bin/ls -S -r -1 ${WORKINGDIR}/finallists/) ; do
    echo $each
    QUERY="LOAD DATA LOCAL INFILE '${WORKINGDIR}/finallists/$each' INTO TABLE statistics FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n'"
    time /usr/bin/mysql --local-infile=1 -u root -h service-0-1 -p<SECRET> -D $MyDB -Be "$QUERY"
done



