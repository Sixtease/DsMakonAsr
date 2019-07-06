infile="$1"

export LD_LIBRARY_PATH=/home/kruza/local/lib
dsasrdir=/home/kruza/dsasr
dsdir=/home/kruza/git/DeepSpeech
: ${outdir:='.'}
bn=`basename "$infile" | sed s/.wav//`
outfile="$outdir/$bn.txt"

#if [ -e "$outfile" ]; then echo file "$outfile" exists; exit 0; fi

"/home/kruza/local/bin/deepspeech" --model "$dsasrdir"/model/output_graph.pb --alphabet "$dsasrdir"/res/alphabet.txt --lm "$dsasrdir"/data/lm/lm.binary --trie "$dsasrdir"/data/lm/trie --audio "$infile" > "$outfile"
