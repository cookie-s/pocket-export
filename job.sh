#!/bin/sh

set -euo pipefail

BRANCH_DATA="data"
BRANCH_CODE="master"

# https://stackoverflow.com/questions/3349105/how-can-i-set-the-current-working-directory-to-the-directory-of-the-script-in-ba
cd "$(dirname "$(realpath "$0")")"

trap "git checkout $BRANCH_CODE" EXIT

# https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
export GIT_AUTHOR_NAME="bot@$(hostname)"
export GIT_AUTHOR_EMAIL="none"
export GIT_COMMITTER_NAME="bot@$(hostname)"
export GIT_COMMITTER_EMAIL="none"
export GIT_SSH_COMMAND='ssh -i .git/id_ed25519'

sh ./retrieve.sh \
    | jq -S '.list | to_entries | map(.value) | sort_by(- .sort_id)' \
    | grep -F -v '"since":'   `# 無駄に更新される情報の無視` \
    | grep -F -v '"sort_id":' `# 無駄に更新される情報の無視` \
    > export-new.json

git checkout "$BRANCH_DATA"
mv export-new.json export.json
git add export.json
git commit --no-gpg-sign -m "auto commit"
git push
git checkout "$BRANCH_CODE"
