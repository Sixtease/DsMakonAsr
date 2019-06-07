. /home/kruza/virtualenv/deepspeech/bin/activate

infile="$1"

dsasrdir=/home/kruza/dsasr
dsdir=/home/kruza/git/DeepSpeech
${outdir:='.'}
bn=`basename "$infile" | sed s/.wav//`
outfile="$outdir/$bn.txt"

if [ -e "$outfile" ]; then echo file "$outfile" exists; exit 0; fi

"$dsdir"/deepspeech "$dsasrdir"/model/output_graph.pb "$dsasrdir"/res/alphabet.txt "$dsasrdir"/data/lm/lm.binary "$dsasrdir"/data/lm/trie "$infile" > "$outfile"

