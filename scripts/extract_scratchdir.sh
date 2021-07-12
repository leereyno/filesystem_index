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

if [ $# -lt 1 ] ; then
    echo -e "\nGotta give me a directory in /scratch to work with\n"
    exit
fi

if [ ! -d /scratch/$1 ] ; then
    echo -e "\nThe directory /scratch/$1 does not exist\n"
    exit 1
fi

MyUSER="root"                    # USERNAME                                     
MyPASS="<SECRET>"                 # PASSWORD                                        
MyHOST="service-0-1"            # Hostname                                      
MyDB="beegfs_scratch_statistics"         # Database to use                      
MYSQL="$(which mysql)"          # Path to mysql                                 
                                                                                
MyConn="$MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -D $MyDB -Be"                    

export CHECKDATE="$(date +%F)"

IFS=$(echo -en "\n\b")

PATH=/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/packages/sysadmin/agave/scripts/:/packages/7x/perl5lib/bin:/opt/puppetlabs/bin:/root/bin

THISDIR=$(pwd)
#WORKINGDIR="/packages/7x/sysadmin/scratch_monitor/beegfs_scratch_statistics"
WORKINGDIR="/root/"

if [ ! -d ${WORKINGDIR}/findlists ] ; then
    mkdir -p ${WORKINGDIR}/findlists
fi

if [ ! -d ${WORKINGDIR}/finallists ] ; then
    mkdir -p ${WORKINGDIR}/finallists
fi

if [ ! -d ${WORKINGDIR}/failed ] ; then
    mkdir -p ${WORKINGDIR}/failed
fi

if [ ! -d ${WORKINGDIR}/completed ] ; then
    mkdir -p ${WORKINGDIR}/completed
fi

/bin/rm -f ${WORKINGDIR}/findlists/$1
/bin/rm -f ${WORKINGDIR}/finallists/$1
/bin/rm -f ${WORKINGDIR}/failed/$1
/bin/rm -f ${WORKINGDIR}/completed/$1

cd /scratch/$1

find -exec stat -c\"%n\",\"%F\",\"%u\",\"%g\",\"%U\",\"%G\",\"%s\",\"%x\",\"%y\",\"%z\" >> ${WORKINGDIR}/findlists/$1 {} \+
#find -exec stat -c\"%N\",\"%F\",\"%u\",\"%g\",\"%U\",\"%G\",\"%s\",\"%x\",\"%y\",\"%z\" >> ${WORKINGDIR}/findlists/$1 {} \+

if [ $? -ne 0 ] ; then
    echo $1 > ${WORKINGDIR}/failed/$1
else
    echo $1 > ${WORKINGDIR}/completed/$1
fi

# Remove bogus info from date fields and add the checkdate and rootdir fields to each entry
${THISDIR}/cleanup $CHECKDATE $1 ${WORKINGDIR}/findlists/$1 > ${WORKINGDIR}/finallists/$1

