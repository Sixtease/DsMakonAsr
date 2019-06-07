#!/usr/bin/perl

# realign-sub.pl had a bug that made array of arrays;
# this is to compensate the result

use 5.010;
use strict;
use warnings;
use utf8;

use Subs qw(decode_subs encode_subs);

my $outdir = shift @ARGV;

for my $subfn (@ARGV) {
    my $subs = decode_subs($subfn);
    my @data;
    for my $rec (@{ $subs->{data}}) {
        if (ref $rec eq 'ARRAY') {
            push @data, @$rec;
        }
        else {
            push @data, $rec;
        }
    }
    my $outfn = "$outdir/$stem.sub.js";
    open my $outfh, '>', $outfn or die "Couldnot open '$outfn' for writing: $!";
    print {$outfh} encode_subs($subs->{filestem}, \@data);
}
