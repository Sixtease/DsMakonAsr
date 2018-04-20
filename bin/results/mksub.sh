#!/bin/bash

stem="$1"
PW="$PWD"

bin/deasciize.pl < "data/recout/ascii/$stem.txt" > "data/recout/utf8/$stem.txt"

cd "$MAKON_FM_DIR"

carton exec perl "$PW/bin/results/align.pl" "$stem"
