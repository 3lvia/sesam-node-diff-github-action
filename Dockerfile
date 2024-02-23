# Container image that runs your code
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "entrypoint.sh" ]