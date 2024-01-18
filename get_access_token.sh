ACCESS_TOKEN=`curl --request POST http://$HOST:$PORT/auth/realms/$MASTER_REALM/protocol/openid-connect/token --header "Accept: application/json" --header "Content-Type: application/x-www-form-urlencoded" --data "grant_type=password&username=$USERNAME&password=$PASSWORD&client_id=$CLIENTNAME&scope=offline_access" | jq -r .access_token`

echo $ACCESS_TOKEN
echo $ACCESS_TOKEN | jwtd | jq .
