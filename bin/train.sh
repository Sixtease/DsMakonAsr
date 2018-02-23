#!/bin/bash

. "$DSH/bin/activate"

"$DSH/DeepSpeech.py" --train_files data/train.csv --dev_files data/dev.csv --test_files data/test.csv --alphabet_config_path res/alphabet.txt --export_dir model --decoder_library_path "$DSH/libctc_decoder_with_kenlm.so" --lm_binary_path data/lm/lm.binary --lm_trie_path data/lm/trie
