#!/bin/bash

USERNAME=admin
PASSWORD=password
CLIENTNAME=admin-cli
MASTER_REALM=master
REALM=master
HOST=localhost
PORT=8080

. ./get_access_token.sh
RESP=`curl --request POST http://$HOST:$PORT/auth/realms/$MASTER_REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" --data "grant_type=password&username=$USERNAME&password=$PASSWORD&client_id=$CLIENTNAME&scope=offline_access"`

echo "RESP: $RESP"

REFRESH_TOKEN=`echo $RESP | jq -r .refresh_token`
echo -n "REFRESH_TOKEN:"
echo $REFRESH_TOKEN | jwtd | jq .

ACCESS_TOKEN=`echo $RESP | jq -r .access_token`
echo -n "ACCESS_TOKEN:"
echo $ACCESS_TOKEN | jwtd | jq .

echo "sleep 1 sec..........."
sleep 1

#NEW_RESP=`curl --request POST http://$HOST:$PORT/auth/realms/$MASTER_REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" --data "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN&username=$USERNAME&password=$PASSWORD&client_id=$CLIENTNAME&scope=offline_access"`
NEW_RESP=`curl --request POST http://$HOST:$PORT/auth/realms/$MASTER_REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" --data "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN&client_id=$CLIENTNAME&scope=offline_access"`
NEW_ACCESS_TOKEN=`echo $NEW_RESP | jq -r .access_token`
echo -n "NEW_ACCESS_TOKEN:"
echo $NEW_ACCESS_TOKEN | jwtd | jq .
