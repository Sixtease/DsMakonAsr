#!/bin/bash

$DSH/native_client/kenlm/build/bin/build_binary -T -s data/lm/lm.arpa data/lm/lm.binary
(echo '<'; echo '>'; echo '/'; cat res/alphabet.txt) > temp/lm-alphabet.txt
$DSH/native_client/generate_trie temp/lm-alphabet.txt data/lm/lm.binary data/lm/wordlist data/lm/trie
rm temp/lm-alphabet.txt
