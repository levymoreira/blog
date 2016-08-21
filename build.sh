#!/usr/bin/env bash
bundle exec jekyll build
rsync -u -a _site/ ../levymoreira.github.io/