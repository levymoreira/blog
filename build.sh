#!/usr/bin/env bash

#########################################
# Build and deploy the blog             #
# Run with: ./build.sh "Commit message" #
#########################################


# Purge cache
curl https://www.cloudflare.com/api_json.html \
  -d 'a=fpurge_ts' \
  -d 'tkn=X' \
  -d 'email=levymoreira.ce@gmail.com' \
  -d 'z=levymoreira.com' \
  -d 'v=1'

  