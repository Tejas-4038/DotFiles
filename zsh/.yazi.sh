#!/usr/bin/env zsh

tmp=$(mktemp -t yazi-cwd.XXXXXX)
yazi "$@" --cwd-file="$tmp"
cwd=$(cat "$tmp")
rm -f "$tmp"
cd "$cwd"
exec zsh
