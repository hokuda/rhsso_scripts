#!/bin/bash

USERNAME=admin
PASSWORD=password
CLIENTNAME=admin-cli
REALM=master
HOST=localhost
PORT=8080

. ./get_access_token.sh


curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/admin/realms/$REALM/users/" | jq .

echo -n "user count: "
curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/admin/realms/$REALM/users/count"
echo
