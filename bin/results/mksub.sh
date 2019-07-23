#!/bin/bash

stem="$1"
PW="$PWD"

getfrom() {
    echo $@ | grep -o -- '--from-[0-9.]*' | sed 's/^--from-//'
}
getto() {
    echo $@ | grep -o -- '--to-[0-9.]*[0-9]' | sed 's/^--to-//'
}

is_first=1

echo "jsonp_subtitles({ \"filestem\": \"$stem\", \"data\":["

for s in "data/recout/ascii/$stem"--*; do
    bn="`basename $s`"
    utffn="$PW/data/recout/utf8/$bn"
    if [ -e "$utffn" ]; then : ; else
        bin/deasciize.pl < "$s" > "$utffn"
    fi

    pushd "$MAKON_FM_DIR" > /dev/null
    from=`getfrom $s`
    to=`getto $s`
    if [ $is_first ]; then : ; else echo ',' ; fi
    carton exec perl "$PW/bin/results/align.pl" "$stem" "$utffn" $from $to
    popd > /dev/null

    is_first=
done

echo "]});"
