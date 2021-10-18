#!/usr/bin/env bash
set -e

sleep 10


all="curl -s https://holded.itgaiden.com/all | q '.'"
p004 = "curl -s https://holded.itgaiden.com/pokemon/004 | q '.'"
pname004 = "curl -s https://holded.itgaiden.com/pokemon/004 | q '.Name'"


echo "Checking localhost or endpoint '/'"
if $(curl -s -I localhost | grep 200 >/dev/null);
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "Checking endpoint '/all'"
string=$(curl -s localhost/all)
if [all = $string];
then
  echo "Test passed, expected value."
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "Checking endpoint '/pokemon/004'"
if [[ $pname004 -eq "Charmander" ]]; then
then
  echo "Test passed, expected value."
else
  echo "Not a 200 HTTP status code or wrong expected value"
  exit 1
fi

# echo "Checking endpoint '/all'"
# string=$(curl -s localhost/all)
# if  <<<"$json_string";
# then
#   echo "Test passed"
# else
#   echo "Not a 200 HTTP status code"
#   exit 1
# fi

# echo "Checking endpoint '/all'"
# string=$(curl -s localhost/all)
# if  <<<"$json_string";
# then
#   echo "Test passed"
# else
#   echo "Not a 200 HTTP status code"
#   exit 1
# fi