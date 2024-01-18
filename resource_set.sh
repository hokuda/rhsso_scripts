#!/bin/bash

USERNAME=alice
PASSWORD=password
CLIENTNAME=app-authz-vanilla
CLIENTSECRET=secret
REALM=quickstart
HOST=localhost
PORT=8180

ACCESS_TOKEN=`curl --request POST http://$HOST:$PORT/auth/realms/$REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" -u $CLIENTNAME:$CLIENTSECRET --data "grant_type=client_credentials" 2>/dev/null | jq -r .access_token`

URI="/uri1"
RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/resource_set" 2>/dev/null`
for id in `echo $RESPONSE | jq -r .[]`
do
    RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/resource_set/$id" 2>/dev/null`
    for uri in `echo $RESPONSE | jq ".uris | .[]"`
    do
        if [[ "\"$URI\"" == $uri ]]
        then 
            RESOURCE_NAME=`echo $RESPONSE | jq -r .name`
            echo "$RESOURCE_NAME"
            curl --location --request POST "http://$HOST:$PORT/auth/realms/$REALM/protocol/openid-connect/token" \
                 --header "Authorization: Bearer $ACCESS_TOKEN" \
                 --header "Content-Type: application/x-www-form-urlencoded" \
                 --data-urlencode "audience=$CLIENTNAME" \
                 --data-urlencode "response_mode=permissions" \
                 --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:uma-ticket" \
                 --data-urlencode "permission=$RESOURCE_NAME"
            echo
        fi
    done
done

