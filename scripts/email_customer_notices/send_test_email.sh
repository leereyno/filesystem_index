#!/bin/bash

# This script sends out emails to users whose Agave scratch usage is greater than 100 gigabytes

# Do not proceed while the database of scratch usage is being updated
#while [ "$(ps afwwux | grep -v grep | grep -i update_usage_database.sh)" ] ; do 
#    sleep 60
#done

IFS=$(echo -en "\n\b")

# Path to where everything lives
SCRATCHMONPATH="/packages/7x/sysadmin/scratch_monitor"

# Config file path
CONFIGPATH="$SCRATCHMONPATH/data"

### LDAP Boilerplage ###

LDAP_SERVER="agaveldap.agave.rc.asu.edu"
LDAP_OU="People"
LDAP_DC="Agave"

#   100,000,000,000 = 100 GB
# 1,000,000,000,000 = 1 TB

QUERY="select
		name,
        DATE_FORMAT(checked, '%Y-%m-%d') as sampledate,
		format(used / 1000000000000,0) as terabytes,
		format(used / 1000000000,0) as gigabytes,
		format(used,0) as bytes
	from
		lastusage
	where
		name = 'leereyno'
	order by used desc"

# 100,000,000,000

#        name = 'leereyno'
#		used >= '100000000000'
for each in $(mysql -h slurmdb.agave.rc.asu.edu -u root -p<SECRET> -D beegfs_scratch_usage -BNe "$QUERY" 2>/dev/null); do

    echo $each

    NAME=$(echo $each | cut -f1)
    SAMPLEDATE=$(echo $each | cut -f2)
	TERABYTES=$(echo $each | cut -f3)
	GIGABYTES=$(echo $each | cut -f4)
    SIZE=$(echo $each | cut -f5)

	# Get full name of user
    USER_NAME="$(ldapsearch -LLL -h $LDAP_SERVER -x -b "ou=$LDAP_OU,dc=$LDAP_DC" \
                    "cn=$NAME" displayName | perl -p00e 's/\r?\n //g' \
                    | grep ^displayName | awk -F': ' '{ print $2 }')"

	# Get email address of user
    USER_EMAIL="$(ldapsearch -LLL -h $LDAP_SERVER -x -b "ou=$LDAP_OU,dc=$LDAP_DC" \
                    "cn=$NAME" mail | perl -p00e 's/\r?\n //g' \
                    | grep ^mail | awk -F': ' '{ print $2 }')"

    #echo -e "$NAME\t$USER_NAME\t$USER_EMAIL\t$GIGABYTES"

	# Create message for this user
    cp $CONFIGPATH/email_template.mime /tmp/$NAME-message.mime

	# Update message with details specific to this user
	sed -e "s/__CUSTOMER__/$USER_NAME/g" \
        -e "s/__SAMPLEDATE__/$SAMPLEDATE/g" \
		-e "s/__USER_EMAIL__/$USER_EMAIL/g" \
		-e "s/__NAME__/$NAME/g" \
		-e "s/__BYTES__/$GIGABYTES/g" \
		-i /tmp/$NAME-message.mime

    sendmail -t < /tmp/${NAME}-message.mime
#   # Send the fuss message out to our user and CC the admin team
#   cat  /tmp/$NAME-message.html | \
#   	mutt -F $CONFIGPATH/muttconfig \
#       -s "High Scratch Usage Advisory" \
#       -c opsteam@hpchelp.asu.edu \
#       $USER_EMAIL

#   /bin/rm -f /tmp/$NAME-message.html

done

#        -c opsteam@hpchelp.asu.edu \
#        $USER_EMAIL

#		Lee.Reynolds@asu.edu


#        -c DL.ORG.UTO.Ops.Research.Computing.Ops@exchange.asu.edu \
#       -c Johnathan.Lee@asu.edu \

