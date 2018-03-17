#!/bin/bash

: ${ASRH:="$PWD"}

cd "$DSH"

# do not forget to . bin/activate virtualenv

./DeepSpeech.py \
    --alphabet_config_path "$ASRH/res/alphabet.txt" \
    --checkpoint_dir "$ASRH/temp/checkpoints" \
    --checkpoint_secs 900 \
    --decoder_library_path "$DECODER_LIB" \
    --dev_batch_size 80 \
    --dev_files "$ASRH/data/dev.csv" \
    --display_step 5 \
    --export_dir "$ASRH/model" \
    --fulltrace true \
    --lm_binary_path "$ASRH/data/lm/lm.binary" \
    --lm_trie_path "$ASRH/data/lm/trie" \
    --max_to_keep 3 \
    --summary_dir "$ASRH/temp/summaries" \
    --summary_secs 900 \
    --test_batch_size 40 \
    --test_files "$ASRH/data/test.csv" \
    --train_batch_size 80 \
    --train_files "$ASRH/data/train.csv" \
    --validation_step 5 \
    --wer_log_pattern "GLOBAL LOG: logwer(%%s, %%s, %%f)" \
    "$@"
