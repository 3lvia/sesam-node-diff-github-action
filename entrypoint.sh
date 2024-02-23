#! /bin/sh

if $INPUT_DOWNLOAD = "true"; then
  echo "Downloading config from $INPUT_NODE"
  curl "https://$INPUT_NODE/api/config" \
  -H 'accept: application/zip' \
  -H "authorization: bearer $INPUT_JWT" \
  --compressed \
  -o /tmp/sesam_download_config.zip 

    unzip /tmp/sesam_download_config.zip -d /tmp/sesam_download_config 
    mkdir -p ./$INPUT_CONFIG_PATH_DOWNLOAD
    cp /tmp/sesam_download_config/* ./$INPUT_CONFIG_PATH_DOWNLOAD 
    rm -rf /tmp/sesam_download_config /tmp/sesam_download_config.zip 
else
  echo "Uploading config to Sesam"
fi

git diff --no-index $@ -- $INPUT_CONFIG_PATH_LOCAL/ $INPUT_CONFIG_PATH_DOWNLOAD/

# If there are differences, git exits with 1. We want to ignore this and give exit code 0 back to github actions

exit 0

