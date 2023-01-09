#!/bin/sh

set -euo pipefail

BRANCH_DATA="data"
BRANCH_CODE="master"

trap "git checkout $BRANCH_CODE" EXIT

# https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
export GIT_AUTHOR_NAME="bot@$(hostname)"
export GIT_AUTHOR_EMAIL="none"
export GIT_COMMITTER_NAME="bot@$(hostname)"
export GIT_COMMITTER_EMAIL="none"
export GIT_SSH_COMMAND='ssh -i .git/id_ed25519'

sh ./retrieve.sh | jq -S '.' > export-new.json

git checkout "$BRANCH_DATA"
mv export-new.json export.json
git add export.json
git commit --no-gpg-sign -m "auto commit"
git push
git checkout "$BRANCH_CODE"
