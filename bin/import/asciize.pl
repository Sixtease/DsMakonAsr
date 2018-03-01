#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Asciize qw(asciize);

undef $/;

while (<>) {
    asciize($_);
    print;
}
