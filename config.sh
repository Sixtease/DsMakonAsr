#!/bin/bash

export PATH="$PATH:bin"
export MAKONFM_TEST_TRACKS="76-05B-Kaly-10:82-01A:kotouc-S01-c:86-05A-Brno-9.2.1986-3:90-45A"
export MAKONFM_TEST_START_POS=60    # take testing data from 1 minute into the track
export MAKONFM_TEST_END_POS=660     # up to minute 11 (10 minutes total per track)
export MAKONFM_SUB_DIR='TODO /path/to/subs'
export AUDIO_DIR='TODO /path/to/flac'
export DSH='TODO /path/to/DeepSpeech'
export ALPHABET_FN='res/alphabet.txt'
export WIDE_ALPHABET_FN='res/wide-alphabet.txt'
export PERL5LIB="$PERL5LIB:./lib"

if [ -r config_local.sh ]; then
    . config_local.sh
fi

export DECODER_LIB="${NATIVE_CLIENT_DIR:-$DSH/libctc_decoder_with_kenlm.so}"

export SUBS_MASK="$MAKONFM_SUB_DIR/*.sub.js"
