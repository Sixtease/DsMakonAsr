. ~/virtualenv/ds3/bin/activate
export LD_LIBRARY_PATH=/home/kruza/local/lib

stem="$1"

wavdir=/net/cluster/TMP/kruza/wav
flacdir=/net/data/makon/flac
mp3dir=/net/data/makon/mp3
dsasrdir=/home/kruza/dsasr
dsdir=/home/kruza/local/bin
recoutdir="$dsasrdir/data/results/recout/ascii"

if [ -e "$recoutdir/$stem.txt" ]; then echo file $stem exists >&2; exit 0; fi

if [ -e "$wavdir/$stem.wav" ]; then :
elif [ -e "$flacdir/$stem.flac" ]; then
    sox "$flacdir/$stem.flac" --channels 1 "$wavdir/$stem.wav" remix - rate -v 16k
elif [ -e "$mp3dir/$stem.mp3" ]; then
    sox "$flacdir/$stem.mp3" --channels 1 "$wavdir/$stem.wav" remix - rate -v 16k
else
    echo no source for $stem
    exit 1
fi

sox "$wavdir/$stem.wav" "$wavdir/splits-$stem.wav" trim 0 1000 : newfile : restart

for s in "$wavdir/splits-$stem"*.wav; do
    "$dsdir"/deepspeech \
        --model "$dsasrdir"/model/output_graph.pb \
        --alphabet "$dsasrdir"/res/alphabet.txt \
        --lm "$dsasrdir"/data/lm/makon-tg.binary \
        --trie "$dsasrdir"/data/lm/makon.trie \
        --audio "$s" \
        > "$s.txt"
    rm "$s"
done

cat "$wavdir/splits-$stem"*.wav.txt > "$recoutdir/$stem.txt"
rm "$wavdir/$stem.wav"
