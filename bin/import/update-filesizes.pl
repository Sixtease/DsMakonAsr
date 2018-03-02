#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;

while (<>) {
    my ($filename, undef, $rest) = split /,/, $_, 3;
    if (-e $filename) {
        my $filesize = (stat($filename))[7];
        print join(',', $filename, $filesize, $rest);
    }
    else {
        print;
    }
}
