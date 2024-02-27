#! /bin/sh

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

  mv /tmp/sesam/DOWNLOAD $INPUT_CONFIG_PATH_DOWNLOAD

else
  echo "Only do diff, not downloading config from $INPUT_NODE"
fi

# Check if there are differences between the downloaded config and the local config
git diff --no-index $@ -- $INPUT_CONFIG_PATH_DOWNLOAD $INPUT_CONFIG_PATH_LOCAL

# If there are differences, git exits with 1. We want to ignore this and give exit code 0 back to github actions

exit 0

