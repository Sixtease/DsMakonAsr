#!/bin/bash

# RUN THIS FIRST:
# . config.sh

bin/import/get_humanic_subs.pl $SUBS_MASK > data/humanic_subs.txt
bin/import/subs2train.pl < data/humanic_subs.txt "$AUDIO_DIR" data data/temp-train.csv data/wide-test.csv data/wide-corpus.txt
awk -f bin/import/split-train-dev.awk data/temp-train.csv

bin/import/asciize.pl < data/wide-train.csv > data/train.csv
bin/import/asciize.pl < data/wide-dev.csv > data/dev.csv
bin/import/asciize.pl < data/wide-test.csv > data/test.csv
bin/import/asciize.pl < data/wide-corpus.csv > data/corpus.csv

rm data/temp-train.csv
