#!/bin/bash

# RUN THIS FIRST:
# . config.sh

bin/import/get_humanic_subs.pl $SUBS_MASK | bin/import/subs2train.pl "$AUDIO_DIR" data data/temp-train.csv data/test.csv data/corpus.txt
awk -f bin/import/split-train-dev.awk data/temp-train.csv
rm data/temp-train.csv
