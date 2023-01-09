#!/bin/sh

set -euo pipefail

source ./.env

API_GET="https://getpocket.com/v3/get"


curl -sfL "$API_GET" \
    -F "consumer_key=$CONSUMER_KEY" \
    -F "access_token=$ACCESS_TOKEN"

