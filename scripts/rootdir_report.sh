#!/bin/bash

# Only run this on service-0-1

if [ $HOSTNAME != "service-0-1.asu.edu" ] ; then
    echo -e "\nThis script should be run on service-0-1\n"
    exit 1
fi

# Assume that we're looking at every user
NONZERO=false

# Find out if we're only showing users with non-zero usage
if [ $# -gt 0 ] && [ "$1" = "-nz" ] ; then
    NONZERO=true
fi

CHECKDATE="$(mysql -D beegfs_scratch_statistics -N -e 'select checkdate from statistics limit 1')"

MAXDAYS=120
LDAP=agaveldap.agave.rc.asu.edu
DCNAME=agave

echo -n "CHECKDATE,"
echo -n "DIRECTORY,"
echo -n "USER ASURITE,"
echo -n "USER FULL NAME,"
echo -n "SPONSOR ASURITE,"
echo -n "SPONSOR FULL NAME,"
echo -n "SPONSOR DEPARTMENT,"
echo -n "SPONSOR COLLEGE,"
echo -n "TOTAL FILES,"
echo -n "TOTAL GB,"

for period in $(seq 30 30 $MAXDAYS) ; do
	echo -n "FILES LAST ACCESS < $period,"
	echo -n "GB LAST ACCESS < $period,"
done

for period in $(seq 30 30 $MAXDAYS) ; do
	echo -n "FILES LAST MODIFIED < $period,"
	echo -n "GB LAST MODIFIED < $period,"
done

echo ""

# Create user list
/bin/rm -f /tmp/userlist
mysql -D beegfs_scratch_statistics -N -e "select distinct rootdir from statistics into outfile '/tmp/userlist'"

for ROOTDIR in $(cat /tmp/userlist) ; do

	# Get the total number of files in the direcory
	FILECOUNT=$(mysql -N -D beegfs_scratch_statistics -Be "select count(*) from statistics where rootdir='$ROOTDIR'")
	FILESUM=$(mysql -N -D beegfs_scratch_statistics -Be "select round(sum(size)/1000000000) from statistics where rootdir='$ROOTDIR'")

    # Skip to the next user if we're only showing non zero users and this user is consuming no space
    if [ $NONZERO = true ] && [ $FILECOUNT -eq 1 ] && [ $FILESUM -eq 0 ] ; then
        continue
    fi

	# Search for all users on Agave first                                      
	LDAP="agaveldap.agave.rc.asu.edu"
	DCNAME="Agave"

	# Who does this root directory belong to?
	ROOTDIRUID=$(mysql -N -D beegfs_scratch_statistics -Be "select uid from statistics where rootdir='$ROOTDIR' and path ='.' and filetype='directory'")

	# If the directory is owned by root, then don't try to extract information
	if [ $ROOTDIRUID -eq 0 ] ; then
		USERNAME="root"
		FULLNAME="Root Account"
		SPONSORASURITE="N/A"
		SPONSORFULL="N/A"
		SPONSORINFO="N/A,N/A"

	else # The user isn't root, so let's figure out who it is

		# See if we can extract the ASURITE user name
		USERNAMETEMP="$(ldapsearch -x -LLL -h $LDAP -b "ou=People,dc=$DCNAME" uidnumber=$ROOTDIRUID cn | grep ^cn | awk -F': ' '{ print $2 }')"

		# Can't find it on Agave, switch to Saguaro
		if [ -z "$USERNAMETEMP" ] ; then

			LDAP="ldap1.local"
			DCNAME="Saguaro"

			USERNAMETEMP="$(ldapsearch -x -LLL -h $LDAP -b "ou=People,dc=$DCNAME" uidnumber=$ROOTDIRUID cn | grep ^cn | awk -F': ' '{ print $2 }')"

			# Still no luck?  Assume unknown user
			if [ -z "$USERNAMETEMP" ] ; then
				USERNAME="UNKNOWN"
				FULLNAME="Unknown Account"
				SPONSORASURITE="N/A"
				SPONSORFULL="N/A"
				SPONSORINFO="N/A,N/A"
			fi				
			
		fi

		# We got an actual username, so find out who it is
		if [ ! -z "$USERNAMETEMP" ] ; then

			# The username is what we found above
			USERNAME=$USERNAMETEMP

			# Get full name
			FULLNAME="$(ldapsearch -x -LLL -h $LDAP -b "ou=People,dc=$DCNAME" cn=$USERNAMETEMP displayName | grep ^displayName | awk -F': ' '{ print $2 }')"

			# Get sponsor asurite
			SPONSORASURITE="$(ldapsearch -x -LLL -h $LDAP -b "ou=People,dc=$DCNAME" cn=$USERNAMETEMP carLicense | grep ^carLicense | awk -F': ' '{ print $2 }')"

			# Get sponsor fullname 
			SPONSORFULL="$(ldapsearch -x -LLL -h $LDAP -b "ou=People,dc=$DCNAME" cn=$SPONSORASURITE displayName | grep ^displayName | awk -F': ' '{ print $2 }')"

			# Get sponsor department and college
			SPONSORINFO=$(mysql -h slurmdb.agave.rc.asu.edu -D slurm_aux_db -N -e "select department,college from show_people where name='$SPONSORASURITE'" | tr '\t' ',')

		fi

	fi

	echo -n -e "$CHECKDATE,"
	echo -n -e "$ROOTDIR,"
	echo -n -e "$USERNAME,"
	echo -n -e "$FULLNAME,"
	echo -n -e "$SPONSORASURITE,"
	echo -n -e "$SPONSORFULL,"
	echo -n -e "$SPONSORINFO,"
	echo -n -e "$FILECOUNT,"
	echo -n -e "$FILESUM,"

	for querytype in lastaccess lastmodify ; do

		for period in $(seq 30 30 $MAXDAYS) ; do

#			QUERY="select count(*) as filecount ,sum(size) as filesize from statistics where rootdir='$ROOTDIR' and $querytype > DATE_SUB('$CHECKDATE' , INTERVAL $period DAY);"
			QUERY="select count(*) as filecount ,round(sum(size)/1000000000) as filesize from statistics where rootdir='$ROOTDIR' and $querytype > DATE_SUB('$CHECKDATE', INTERVAL $period DAY);"

			OUTPUT=$(mysql -N -D beegfs_scratch_statistics -Be "$QUERY")

			FIRST=$(echo $OUTPUT | awk '{ print $1 }')
			SECOND=$(echo $OUTPUT | awk '{ print $2 }')

			if [ $SECOND = "NULL" ] ; then
				SECOND=0
			fi

			echo -n "$FIRST,$SECOND"

			if [ "$querytype" == "lastaccess" ] ; then
				echo -n ","
			else 
				if [ "$querytype" == "lastmodify" ] ; then
					if [ $period -ne $MAXDAYS ] ; then
						echo -n ","
					fi
				fi
			fi
				
		done
	done

	echo ""
done
