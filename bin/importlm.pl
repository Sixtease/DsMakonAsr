#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Asciize qw(asciize);

my ($in_lm_fn, $out_vocab_fn) = @ARGV;
open my $in_lm_fh, '<:encoding(iso-8859-2)', $in_lm_fn or die "Couldn't open language model '$in_lm_fn': $!";
open my $out_vocab_fh, '>:utf8', $out_vocab_fn or die "Couldn't open output vocabulary file '$out_vocab_fn': $!";

while (<$in_lm_fh>) {
    my $normalized = lc;
    asciize($normalized);
    print $normalized;
    if (/\\1-grams:/ .. /^$/) {
        if ($normalized =~ /^\S+\s+(\S+)/) {
            print {$out_vocab_fh} lc($1), "\n";
        }
    }
}
