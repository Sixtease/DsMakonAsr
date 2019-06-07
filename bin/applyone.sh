. /home/kruza/virtualenv/deepspeech/bin/activate

stem="$1"

wavdir=/net/cluster/TMP/kruza/wav
flacdir=/net/data/makon/flac
dsasrdir=/home/kruza/dsasr
dsdir=/home/kruza/git/DeepSpeech

if [ -e "$dsasrdir/data/results/$stem.txt" ]; then echo file $stem exists; exit 0; fi

if [ -e "$wavdir/$stem.wav" ]; then : ; else
    sox "$flacdir/$stem.flac" --channels 1 "$wavdir/$stem.wav" remix - rate -v 16k
fi

"$dsdir"/deepspeech "$dsasrdir"/model/output_graph.pb "$dsasrdir"/res/alphabet.txt "$dsasrdir"/data/lm/lm.binary "$dsasrdir"/data/lm/trie "$wavdir/$stem.wav" > "$dsasrdir/data/results/$stem.txt" && rm "$wavdir/$stem.wav"
