#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Asciize qw(asciize);

my ($in_lm_fn, $out_vocab_fn) = @ARGV;
(my $wide_out_vocab_fn = $out_vocab_fn) =~ s{/([^/]+)$}{/wide-$1};
open my $in_lm_fh, '<:encoding(iso-8859-2)', $in_lm_fn or die "Couldn't open language model '$in_lm_fn': $!";
open my $out_vocab_fh, '>:utf8', $out_vocab_fn or die "Couldn't open output vocabulary file '$out_vocab_fn': $!";
open my $wide_out_vocab_fh, '>:utf8', $wide_out_vocab_fn or die "Couldn't open wide output vocabulary file '$wide_out_vocab_fn': $!";

while (<$in_lm_fh>) {
    my $normalized = lc;
    $normalized =~ s/!!unk/<unk>/g;
    my $ascii = $normalized;
    asciize($ascii);
    print $ascii;
    if (/\\1-grams:/ .. /^$/) {
        if ($normalized =~ /^\S+\s+(\S+)/) {
            my $match = $1;
            print {$wide_out_vocab_fh} "$match\n";
            asciize($match);
            print {$out_vocab_fh} "$match\n";
        }
    }
}
