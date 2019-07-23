. ~/virtualenv/ds3/bin/activate
. /home/kruza/dsasr/config_local.sh
export LD_LIBRARY_PATH=/home/kruza/local/lib

stem="$1"

# set from env
#wavdir=
#flacdir=
#mp3dir=
#dsasrdir=
#dsbin=
#recoutdir=
#splitmetadir=


if ls "$recoutdir/$stem"*.txt > /dev/null 2>&1; then echo file $stem exists >&2; exit 0; fi

if [ -e "$wavdir/$stem.wav" ]; then :
elif [ -e "$flacdir/$stem.flac" ]; then
    sox "$flacdir/$stem.flac" --channels 1 "$wavdir/$stem.wav" remix - rate -v 16k
elif [ -e "$mp3dir/$stem.mp3" ]; then
    sox "$mp3dir/$stem.mp3" --channels 1 "$wavdir/$stem.wav" remix - rate -v 16k
else
    echo no source for $stem
    exit 1
fi

grep '"from"' "$splitmetadir/$stem.jsonp" | perl -nE '
    INIT { $wavdir = shift; $stem = shift }
    next unless /"from"/;
    next unless /ogg/;
    ($from) = /"from"\s*:\s*([\d.]+)/;
    ($to) = /"to"\s*:\s*([\d.]+)/;
    ($bn) = /"basename"\s*:\s*"([^"]+)/;
    $bn =~ s/\.ogg/.wav/;
    $outfn = "$wavdir/$bn";
    `sox "$wavdir/$stem.wav" "$wavdir/$bn" trim $from =$to`;
    say $outfn;
' "$wavdir" "$stem" | while read s; do
    outfn="$recoutdir/$(basename $s).txt"
    "$dsbin" \
        --model "$dsasrdir"/model/output_graph.pb \
        --alphabet "$dsasrdir"/res/alphabet.txt \
        --lm "$dsasrdir"/data/lm/lm.binary \
        --trie "$dsasrdir"/data/lm/trie \
        --audio "$s" \
        > "$outfn"
    rm "$s"
done

rm "$wavdir/$stem.wav"
