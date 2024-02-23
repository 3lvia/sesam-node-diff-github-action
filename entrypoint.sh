#! /bin/sh

if $INPUT_DOWNLOAD = "true"; then
  echo "Downloading config from $INPUT_NODE"
  curl 'https://$INPUT_NODE/api/config' \
  -H 'accept: application/zip' \
  -H 'authorization: bearer $INPUT_JWT' \
  --compressed \
  -o sesam_download_config.zip && \
    unzip sesam_download_config.zip -d /tmp/sesam_download_config && \
    mv /tmp/sesam_download_config/* $INPUT_CONFIG_PATH_DOWNLOAD && \
    rm -rf /tmp/sesam_download_config
else
  echo "Uploading config to Sesam"
fi

git diff --no-index $@ -- $INPUT_CONFIG_PATH_LOCAL $INPUT_CONFIG_PATH_DOWNLOAD