#!/usr/bin/env bash
fuser -k 4000/tcp
bundle exec jekyll serve --watch
