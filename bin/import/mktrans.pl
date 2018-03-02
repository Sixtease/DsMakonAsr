#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use NormalizeSent qw(normalize);

my $OUT_AUDIO_FORMAT = 'wav';

if (@ARGV != 4) {
    die "USAGE: $0 audio_dir train_out_csv_fn test_out_csv_fn corpus_fn\n";
}
my ($audio_dir, $train_out_csv_fn, $test_out_csv_fn, $out_corpus_fn) = @ARGV;

my %is_test = map {;$_=>1} split /:/, $ENV{MAKONFM_TEST_TRACKS};
my $test_start = $ENV{MAKONFM_TEST_START_POS} || 0;
my $test_end   = $ENV{MAKONFM_TEST_END_POS}   || 'Infinity';

open my $train_csv_fh, '>:utf8', $train_out_csv_fn or die "Couldn't open train.csv '$train_out_csv_fn': $!";
open my $test_csv_fh,  '>:utf8', $test_out_csv_fn  or die "Couldn't open test.csv '$test_out_csv_fn': $!";
open my $corpus_fh,    '>:utf8', $out_corpus_fn    or die "Couldn't open corpus '$out_corpus_fn': $!";

my $log_fh;
if ($ENV{SUB_EXTRACTION_LOG}) {
    open $log_fh, '>', $ENV{SUB_EXTRACTION_LOG};
}

my $headline = "wav_filename,wav_filesize,transcript\n";
print {$train_csv_fh} $headline;
print {$test_csv_fh}  $headline;

$/ = '';
LINE:
while (<STDIN>) {
    my ($head, $sent, $end) = split /\n/;
    my ($sid, $filestem, $start) = split /\s+/, $head;

    my $csv_fh = $train_csv_fh;
    my $is_test_sent = 0;
    if ($is_test{$filestem}
        and $start > $test_start
        and $end   < $test_end
    ) {
        $csv_fh = $test_csv_fh;
        $is_test_sent = 1;
    }

    my $kind = $is_test_sent ? 'test' : 'train';
    print {$log_fh} "$filestem $start .. $end => $sid ($kind)\n" if $log_fh;

    my $out_audio_fn = "$audio_dir/$kind/$sid.$OUT_AUDIO_FORMAT";

    print("$out_audio_fn not found\n"), next if not -e $out_audio_fn;

    my $filesize = (stat($out_audio_fn))[7];

    my $normalized_sent = normalize($sent);
    1 while chomp $normalized_sent;
    print {$csv_fh} qq($out_audio_fn,$filesize,$normalized_sent\n);
    print {$corpus_fh} "$sent\n";
}
