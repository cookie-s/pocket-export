#!/bin/sh

set -euo pipefail

# CONSUMER_KEY=""
OAUTH_REQUEST_URL="https://getpocket.com/v3/oauth/request"
OAUTH_AUTHORIZE_URL="https://getpocket.com/v3/oauth/authorize"
REDIRECT_URL="https://kcz.sh/show-code/"

source ./.env

state="state"

# https://getpocket.com/developer/docs/authentication
request_token="$(curl -sfL "$OAUTH_REQUEST_URL" \
    -H "X-Accept: application/json" \
    -F "consumer_key=$CONSUMER_KEY" \
    -F "redirect_uri=$REDIRECT_URL" \
    -F "state=$state" | jq '.code' -r)"


echo "$request_token"

echo "Go to: https://getpocket.com/auth/authorize?request_token=${request_token}&redirect_uri=${REDIRECT_URL}"

echo "Hit Enter key once you authorize the access"
read _

result="$(curl -sfL "$OAUTH_AUTHORIZE_URL" \
    -H "X-Accept: application/json" \
    -F "consumer_key=$CONSUMER_KEY" \
    -F "code=$request_token")"

echo "$result"

