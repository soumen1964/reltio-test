#!/bin/sh
AUTH_ENDPOINT="https://auth02.reltio.com/oauth/token?"
TENANT_URI="https://test-usg.reltio.com/reltio/api/5d6cjMxNHK4QC4a/configuration"
USERNAME="soumen@2pirad.com"
PASSWORD="Passw0rd@Sou"

echo Getting Access token
CREDENTIALS="$( curl --location --request POST ${AUTH_ENDPOINT}username=$USERNAME'&password='$PASSWORD'&grant_type=password' --header 'Authorization: Basic cmVsdGlvX3VpOm1ha2l0YQ==' | jq -r .access_token )"

echo Access token = $CREDENTIALS

echo Getting current configuration
curl --location ${TENANT_URI}'/_noInheritance' \
--header 'Authorization: Bearer '$CREDENTIALS >old-config.json

res=$?
if test "$res" != "0"; then
   echo "Failed to get current configuration: $res"
   exit 1
fi

echo Updating with new configuration
curl --location --request PUT ${TENANT_URI} \
--header 'Authorization: Bearer '$CREDENTIALS \
--header 'Content-Type: text/plain' \
--data-binary '@../json/configure.json' >output

res=$?
if test "$res" != "0"; then
   echo "the curl command failed with: $res"
fi

res="$(cat output  | grep -i errorCode | wc -c )"

 if [ $res != "0" ]; then
  echo "Failed to update configuration with error : "
  cat output
#  curl --location --request PUT 'https://test-usg.reltio.com/reltio/api/5d6cjMxNHK4QC4a/configuration' \
# --header 'Authorization: Bearer '$CREDENTIALS \
# --header 'Content-Type: text/plain' \
# --data-binary '@./old-config.json' >output
  exit 1;
fi
echo "Configuration updated sucessful"
