#!/bin/zsh
# gum-connect.sh: Ben runs this once (and again if the sign-in expires). It registers the
# Desktop OAuth client saved at ~/private_keys/gum-oauth-client.json with Gum, then opens
# Google's sign-in asking for read-only Search Console access and nothing else.
# The secret goes from the file to Gum on a pipe; it is never printed.
set -eu
GUM=$HOME/.local/bin/gum
KEY=$HOME/private_keys/gum-oauth-client.json
[ -x "$GUM" ] || { echo "Gum isn't installed at $GUM"; exit 1; }
[ -r "$KEY" ] || { echo "No key file at $KEY"; exit 1; }
ID=$(python3 -I -c 'import json,sys; print(json.load(open(sys.argv[1]))["installed"]["client_id"])' "$KEY")
python3 -I -c 'import json,sys; sys.stdout.write(json.load(open(sys.argv[1]))["installed"]["client_secret"])' "$KEY" \
  | "$GUM" auth use-oauth-client --client-id "$ID" --secret-stdin
echo "Key registered. Opening Google's sign-in: choose the search account and click Allow."
echo "The screen should say it can VIEW Search Console data. If it says manage, close it."
"$GUM" login --scope https://www.googleapis.com/auth/webmasters.readonly "$@"
"$GUM" auth status
