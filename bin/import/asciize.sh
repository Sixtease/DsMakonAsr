#!/bin/bash

tmp=/tmp/asciize

for f in "$@"; do
    cp "$f" "$tmp" &&
    perl -Mutf8 -Mopen=:std,:utf8 -E 'tr/áéíóúýčďěňřšťůž/AEIOUYCDJNRSTWZ/, print while <>'  < "$tmp" > "$f"
    rm "$tmp"
done
