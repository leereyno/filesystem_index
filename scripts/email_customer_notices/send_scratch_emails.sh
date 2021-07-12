#!/bin/bash

# This script sends out emails to users whose Agave scratch usage is greater than 100 gigabytes

# Do not proceed while the database of scratch usage is being updated
#while [ "$(ps afwwux | grep -v grep | grep -i update_usage_database.sh)" ] ; do 
#    sleep 60
#done

IFS=$(echo -en "\n\b")

# Path to where everything lives
SCRATCHMONPATH="/packages/7x/sysadmin/beegfs_scratch_statistics/scripts/email_customer_notices/"

# Config file path
CONFIGPATH="$SCRATCHMONPATH/data"

### LDAP Boilerplage ###

LDAP_SERVER="agaveldap.agave.rc.asu.edu"
LDAP_OU="People"
LDAP_DC="Agave"

for line in $(cat customerlist | grep -v '#') ; do
	
	NAME=$(echo $line | awk -F: '{ print $1 }')
	TERABYTES=$(echo $line | awk -F: '{ print $2 }')

    echo $NAME

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
		-e "s/__NAME__/$NAME/g" \
		-e "s/__USER_EMAIL__/$USER_EMAIL/g" \
		-e "s/__BYTES__/$TERABYTES/g" \
		-i /tmp/$NAME-message.mime

    # Send the fuss message out to our user and CC the admin team
    sendmail -t < /tmp/${NAME}-message.mime

    /bin/rm -f /tmp/$NAME-message.mime

done

