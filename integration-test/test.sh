#!/usr/bin/env bash

sleep 10
# Colors to use for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
## Define some variables for lates
str_all=$(curl -s localhost/all)
str_004=$(curl -s localhost/pokemon/004)
str_025=$(curl -s localhost/pokemon/025)

error=0





echo "STARTING TESTS **********************************************************"
echo "Checking endpoint '/'"
####### HTTP Status Code test
if $(curl -s -I localhost | grep 200 >/dev/null);
then
  printf "${GREEN}Test passed${NC}\n"
else
  printf "${RED}Not a 200 HTTP status code${NC}\n"
  exit 1
fi
#######


echo "***********************************************************"
echo "Checking endpoint (GET) '/all'"
## Define some variables to be used later

####### endpoint '/all' test
if jq -e . >/dev/null 2>&1 <<<"$str_all"; then
    printf "${GREEN}Response was successful, test successful${NC}\n"
else
    printf "${RED}Response was unsuccessful, test failed${NC}\n"
    error=1
fi
#######

echo "***********************************************************"
echo "Checking endpoint (GET) '/pokemon/004'"
#######  endpoint '/pokemon/004' Test
if jq -e . >/dev/null 2>&1 <<<"$str_004"; then
    printf "${GREEN}Element retrieved successfully, test successful${NC}\n"
else
    printf "${RED}Element retrieved unsuccessfully, test failed${NC}\n"
    error=1
fi
#######


echo "***********************************************************"
echo "POST request to endpoint /pokemon which will add a new item"
## Append an item using CURL
curl -s -X POST -d '{"Name":"Pikachu","Number":"025","Type":"Electric"}' \
 -H "Content-Type: application/json" localhost/pokemon

Name=$(echo "$str_025" |  jq -r '.Name')
####### POST item test
if [[ $Name -eq "Pikachu" ]]; then
    printf "${GREEN}POST test was successful, $Name as the expected value${NC}\n"
else
    printf "${RED}POST test failed${NC}\n"
    error=1
fi
#######


echo "***********************************************************"
echo "DELETE request to endpoint /pokemon/004 which will delete that item"
## Delete an item using CURL
curl -s -X DELETE localhost/pokemon/004
str_004=$(curl -s localhost/pokemon/004)
## Check if we find the Pokemon.Number (we shouldn't)
Number=$(echo "$str_004" |  jq -r '.Number')
####### DELETE Test
if [[ $Number -ne "004" ]]; then
    printf "${GREEN}DELETE test was successful as the element was not present.${NC}\n"
else
    printf "${RED}DELETE test failed.${NC}\n"
    error=1
fi
#######


# In case there are any errors, the script will exit but first it will
# stop running containers and networks (not in our case) defined in our Compose file.
if [[ $error -eq 1 ]]; then
  docker-compose -f "integration-test/docker-compose.yaml" down
  exit 1
else
  exit 0
fi