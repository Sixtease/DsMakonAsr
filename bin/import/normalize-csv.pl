#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use NormalizeSent qw(normalize);

while (<>) {
    chomp;
    my @f = split /,/, $_, 3;
    my $f0 = shift @f;
    my $sent = shift @f;
    print(join(',', $f0, normalize($sent), @f), "\n");
}
