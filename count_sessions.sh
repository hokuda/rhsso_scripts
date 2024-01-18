#!/bin/bash

USERNAME=admin
PASSWORD=password
CLIENTNAME=admin-cli
MASTER_REALM=master
TARGET_REALM=mydata
PROTOCOL=http
HOST=localhost
PORT=8080
STDERR_LOG=stderr.log


ACCESS_TOKEN=`curl --request POST http://$HOST:$PORT/auth/realms/$TARGET_REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" --data "grant_type=password&username=user2&password=password&client_id=test-client&scope=offline_access" | jq -r .access_token`
echo $ACCESS_TOKEN
echo $ACCESS_TOKEN | jwtd | jq .

. ./get_access_token.sh

for id in `curl -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/clients/" 2>>./$STDERR_LOG| jq -r ".[] | .id"`
do
    client=`curl -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/clients/$id" 2>>./$STDERR_LOG | jq -r ".clientId"`
    echo -n "client session count ($client):"
    curl -k -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "$PROTOCOL://$HOST:$PORT/auth/admin/realms/$TARGET_REALM/clients/$id/session-count" 2>>./$STDERR_LOG | jq -r .count
done

