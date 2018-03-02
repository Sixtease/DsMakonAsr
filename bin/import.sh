#!/bin/bash

# RUN THIS FIRST:
# . config.sh

#bin/import/get_humanic_subs.pl $SUBS_MASK > data/humanic_subs.txt
bin/import/mkwav.pl "$AUDIO_DIR" data < data/humanic_subs.txt
bin/import/mktrans.pl data temp/train-dev.csv data/wide-test.csv data/wide-corpus.txt < data/humanic_subs.txt
awk -f bin/import/split-train-dev.awk temp/train-dev.csv

bin/import/asciize.pl < data/wide-train.csv > data/train.csv
bin/import/asciize.pl < data/wide-dev.csv > data/dev.csv
bin/import/asciize.pl < data/wide-test.csv > data/test.csv
bin/import/asciize.pl < data/wide-corpus.txt > data/corpus.txt

rm temp/train-dev.csv
