#!/usr/bin/perl

# USAGE: $0 files-to-delete input.csv > filtered.csv

use 5.010;
use strict;
use warnings;
use utf8;

my %todel;

while (<>) {
    chomp;
    $todel{$_} = 1;
    last if eof;
}

while (<>) {
    my ($fn) = split /,/;
    print if not $todel{$fn};
}
