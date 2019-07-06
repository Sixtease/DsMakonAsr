#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;

my ($stemlist_fn, $sub_in_dir, $sub_out_dir) = @ARGV;

open my $stemlist_fh, '<', $stemlist_fn or die "Couldn't open filelist '$stemlist_fn' for reading: $!";

chdir '../webapp/MakonFM';

while (<$stemlist_fh>) {
    chomp;
    my $stem = $_;
    $stem =~ s/\s.*//;
    my $output_subfn = "$sub_out_dir/$stem.sub.js";
    system qq(carton exec ../../dsasr/bin/results/realign-sub.pl "$stem" > "$output_subfn");
}
