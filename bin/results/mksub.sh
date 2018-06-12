#!/bin/bash

stem="$1"
PW="$PWD"

if [ -e "data/recout/utf8/$stem.txt" ]; then : ; else
    bin/deasciize.pl < "data/recout/ascii/$stem.txt" > "data/recout/utf8/$stem.txt"
fi

cd "$MAKON_FM_DIR"

carton exec perl "$PW/bin/results/align.pl" "$stem"
