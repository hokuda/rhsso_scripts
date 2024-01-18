#!/bin/bash

USERNAME=alice
PASSWORD=alice
#CLIENTNAME=photoz-html5-client
CLIENTNAME=photoz-restful-api
CLIENTSECRET=secret
REALM=photoz
HOST=localhost
PORT=8180

ACCESS_TOKEN=`curl --request POST http://$HOST:$PORT/auth/realms/$REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" -u $CLIENTNAME:$CLIENTSECRET --data "grant_type=client_credentials" 2>/dev/null | jq -r .access_token`

URI="/album"
RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/resource_set" 2>/dev/null`
echo "RESP0=$RESPONSE"
for id in `echo $RESPONSE | jq -r .[]`
do
    RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/resource_set/$id" 2>/dev/null`
    echo "$id $RESPONSE"
    for uri in `echo $RESPONSE | jq ".uris | .[]"`
    do
        if [[ "\"$URI\"" == $uri ]]
#        if true
        then 
            RESOURCE_NAME=`echo $RESPONSE | jq -r .name`
            #echo "$RESOURCE_NAME"
            curl --location --request POST "http://$HOST:$PORT/auth/realms/$REALM/protocol/openid-connect/token" \
                 --header "Authorization: Bearer $ACCESS_TOKEN" \
                 --header "Content-Type: application/x-www-form-urlencoded" \
                 --data-urlencode "audience=$CLIENTNAME" \
                 --data-urlencode "response_mode=permissions" \
                 --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:uma-ticket" \
                 #--data-urlencode "permission=$RESOURCE_NAME"
                 
            echo
        fi
    done
done




RESOURCE_ID=ee34a3e9-e08e-4fd6-af38-0ce4144b86ba
#RESOURCE_ID=ad17cd93-e4f8-4f85-b07e-1aece7fb5f1a
#RESOURCE_ID=62f92767-8fa1-4b82-9299-408e0adb6757
echo "-----"
curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/uma-policy/" 2>/dev/null
echo "-----"
#RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X GET "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/uma-policy/$RESOURCE_ID" 2>/dev/null`
#echo $RESPONSE

RESPONSE=`curl -H "Authorization: bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -X POST "http://$HOST:$PORT/auth/realms/$REALM/authz/protection/uma-policy/$RESOURCE_ID" -d '{"name": "Any people manager", "description": "Allow access to any people manager", "scopes": ["read"], "roles": ["people-manager"]}' 2>/dev/null`
echo $RESPONSE

