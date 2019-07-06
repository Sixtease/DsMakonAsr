#!/bin/bash

: ${ASRH:="$PWD"}

# do not forget to . bin/activate virtualenv



"$DSH/deepspeech" "$ASRH/model/output_graph.pb" "$ASRH/res/alphabet.txt" "$ASRH/data/lm/lm.binary" "$ASRH/data/lm/trie" "$1"
