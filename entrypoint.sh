#! /bin/sh

prettify() {
    local temp_file
    temp_file=$(mktemp) &&
      jq . < "$1" > "$temp_file" &&
      mv -- "$temp_file" "$1"
}

get_original() {
    local temp_file
    temp_file=$(mktemp) &&
      jq '.config|.original|del(."$audit")?|del(."_updated")?|del(."_deleted")?|del(."_hash")?|del(."_deleted")?|del(."_previous")?|del(."_ts")?' < "$1" > "$temp_file" &&
      mv -- "$temp_file" "$1"
}

if $INPUT_DOWNLOAD = "true"; then
# Make tmp directories
  mkdir -p /tmp/sesam/DOWNLOAD/variables
# Download config from sesam node  
  echo "Downloading config from $INPUT_NODE"
  curl "https://$INPUT_NODE/api/config" \
  -H 'accept: application/zip' \
  -H "authorization: bearer $INPUT_JWT" \
  --compressed \
  -o /tmp/sesam/download_config.zip 
# Unzip config
  unzip /tmp/sesam/download_config.zip -d /tmp/sesam/download_config 
  cp -r /tmp/sesam/download_config/* /tmp/sesam/DOWNLOAD
  rm -rf /tmp/sesam/download_config /tmp/sesam/download_config.zip
# Download variables
  echo "Downloading variables $INPUT_NODE"
  curl "https://$INPUT_NODE/api/env" \
  -H 'accept: application/json' \
  -H "authorization: bearer $INPUT_JWT" \
  --compressed \
  -o /tmp/sesam/DOWNLOAD/variables/variables.json
# Download node metadata
  echo "Downloading metadata from $INPUT_NODE"
  curl "https://$INPUT_NODE/api/metadata" \
  -H 'accept: application/json' \
  -H "authorization: bearer $INPUT_JWT" \
  --compressed \
  -o /tmp/sesam/DOWNLOAD/node-metadata.conf.json

  mkdir -p $INPUT_CONFIG_PATH_DOWNLOAD
  mv /tmp/sesam/DOWNLOAD/node-metadata.conf.json -t $INPUT_CONFIG_PATH_DOWNLOAD
  mv /tmp/sesam/DOWNLOAD/variables -t $INPUT_CONFIG_PATH_DOWNLOAD
  mv /tmp/sesam/DOWNLOAD/pipes -t $INPUT_CONFIG_PATH_DOWNLOAD
  mv /tmp/sesam/DOWNLOAD/systems -t $INPUT_CONFIG_PATH_DOWNLOAD

else
  echo "Only do diff, not downloading config from $INPUT_NODE"
fi

# Check if there are differences between the downloaded config and the local config

echo "´´´diff" >> $GITHUB_STEP_SUMMARY

git diff --diff-algorithm=histogram --no-index $@ -- $INPUT_CONFIG_PATH_DOWNLOAD/systems $INPUT_CONFIG_PATH_LOCAL/systems >> $GITHUB_STEP_SUMMARY
git diff --diff-algorithm=histogram --no-index $@ -- $INPUT_CONFIG_PATH_DOWNLOAD/pipes $INPUT_CONFIG_PATH_LOCAL/pipes >> $GITHUB_STEP_SUMMARY

# Prettify the node and variables json files in order to make the diff more relevant
prettify $INPUT_CONFIG_PATH_DOWNLOAD/variables/variables.json
prettify $INPUT_CONFIG_PATH_LOCAL/variables/variables.json
get_original $INPUT_CONFIG_PATH_DOWNLOAD/node-metadata.conf.json
prettify $INPUT_CONFIG_PATH_LOCAL/node-metadata.conf.json

git diff --diff-algorithm=histogram --no-index $@ -- $INPUT_CONFIG_PATH_DOWNLOAD/variables $INPUT_CONFIG_PATH_LOCAL/variables >> $GITHUB_STEP_SUMMARY
git diff --diff-algorithm=histogram --no-index $@ -- $INPUT_CONFIG_PATH_DOWNLOAD/node-metadata.conf.json $INPUT_CONFIG_PATH_LOCAL/node-metadata.conf.json >> $GITHUB_STEP_SUMMARY

echo "´´´" >> $GITHUB_STEP_SUMMARY

# If there are differences, git exits with 1. We want to ignore this and give exit code 0 back to github actions

exit 0

