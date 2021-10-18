#!/usr/bin/env bash
set -e

sleep 10

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
if  <<<"$json_string";
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "Checking endpoint '/all'"
string=$(curl -s localhost/all)
if  <<<"$json_string";
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "Checking endpoint '/all'"
string=$(curl -s localhost/all)
if  <<<"$json_string";
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi

echo "Checking endpoint '/all'"
string=$(curl -s localhost/all)
if  <<<"$json_string";
then
  echo "Test passed"
else
  echo "Not a 200 HTTP status code"
  exit 1
fi