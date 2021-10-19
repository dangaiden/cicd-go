#!/usr/bin/env bash

set -e

sleep 10
error=0

echo "Checking localhost or endpoint '/'"
if $(curl -s -I localhost | grep 200 >/dev/null);
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "-- Items list response test --"
echo "Testing item list response, looking for a valid json list"
json_string=$(curl -s localhost/all)
if jq -e . >/dev/null 2>&1 <<<"$json_string"; then
    echo "Items list response test passed"
else
    echo "Items list response test failed"
    error=1
fi


echo "-- Single Item query test --"
echo "Testing single Item query , looking for a valid json list"
json_string=$(curl -s localhost/pokemon/004)
if jq -e . >/dev/null 2>&1 <<<"$json_string"; then
    echo "Single Item query test passed"
else
    echo "Single Item query test failed"
    error=1
fi

echo "-- Item creation test --"
echo "Testing Item creation ,looking for a valid json list"
curl -X POST -d '{"Name":"Pikachu","Number":"025","Type":"Electric"}' \
 -H "Content-Type: application/json" localhost/pokemon
json_string=$(curl -s localhost/pokemon/025)
id=$(echo "$json_string" |  jq -r '.Name')
if [[ $id -eq "Pikachu" ]]; then
    echo "Item creation test passed, Pikachu as the expected value"
else
    echo "Item creation test failed"
    error=1
fi

echo "-- Item deletion test --"
echo "Testing Item deletion ,looking for a not valid json list"
curl -s -X DELETE localhost/pokemon/004
json_string=$(curl -s localhost/004)
id=$(echo "$json_string" |  jq -r '.Number')
if [[ $id -eq "004" ]]; then
    echo "Item deletion test failed"
    error=1
else
    echo "Item deletion test passed"
fi





if [[ $error -eq 1 ]]; then
  docker-compose -f "testing/docker-compose.yml" down
  exit 1
else
  exit 0
fi