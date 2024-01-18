#!/bin/bash

USERNAME=admin
PASSWORD=password
CLIENTNAME=admin-cli
MASTER_REALM=master
TARGET_REALM=testrealm1
TARGET_USER=user1
PROTOCOL=http
HOST=localhost
PORT=8080
STDERR_LOG=stderr.log


. ./get_access_token.sh


# get user representation
#USER_REP=`curl -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/users/?username=$TARGET_USER"`
#echo $USER_REP | jq .
#echo $USER_REP | jq '.[] | .id'

# get user id
#ID=`echo $USER_REP | jq -r '.[] | .id'`
#echo $ID

# remove roles
#curl -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X PUT --data '{"realmRoles": []}' "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/users/$ID"
#echo it does not work

# can't remove default-roles-$realm from a user, actually a user does not have an anchor to the role, but RH-SSO system assigns it automotically...

# can't remove default-roles-$realm, because RH-SSO throws NPE at startup, once removed it.
#curl -v -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X DELETE "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/roles/default-roles-testrealm1"

# however, we can remove composite roles of the default-roles-$realm
COMPOSITES=`curl -v -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/roles/default-roles-$TARGET_REALM/composites"`
curl -v -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X DELETE --data "$COMPOSITES" "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/roles/default-roles-$TARGET_REALM/composites"
