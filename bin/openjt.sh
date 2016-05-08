#!/bin/zsh

zmodload zsh/pcre

#pcre_compile "^(\w+)_(\d+)$"
#pcre_match "$@" && echo match || echo no match

STACK=".*\.*.*\.*.*\.*.*"
URL="(https?:\/\/)?([\da-z\.-]+)([a-z\.]{2,6})([\/\w \.-]*)*\/?"
sed -n 's/.*\([0-9][0-9]*G[0-9][0-9]*\).*/\1/p'

if [[ "$@" =~ $URL ]]; then
  echo "its  url"
elif [[ "$@" =~ $STACK ]]; then
  echo "stack"
fi
