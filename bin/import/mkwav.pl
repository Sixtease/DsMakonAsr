#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my $IN_AUDIO_FORMAT = 'flac';
my $OUT_AUDIO_FORMAT = 'wav';

if (@ARGV != 2) {
    die "USAGE: $0 in_audio_dir out_audio_dir\n";
}
my ($in_audio_dir, $out_audio_dir) = @ARGV;

my %is_test = map {;$_=>1} split /:/, $ENV{MAKONFM_TEST_TRACKS};
my $test_start = $ENV{MAKONFM_TEST_START_POS} || 0;
my $test_end   = $ENV{MAKONFM_TEST_END_POS}   || 'Infinity';

$/ = '';
LINE:
while (<STDIN>) {
    my ($head, $sent, $end) = split /\n/;
    my ($sid, $filestem, $start) = split /\s+/, $head;
    my $in_audio_fn = "$in_audio_dir/$filestem.$IN_AUDIO_FORMAT";

    my $is_test_sent = 0;
    if ($is_test{$filestem}
        and $start > $test_start
        and $end   < $test_end
    ) {
        $is_test_sent = 1;
    }

    my $kind = $is_test_sent ? 'test' : 'train';

    my $out_audio_fn = "$out_audio_dir/$kind/$sid.$OUT_AUDIO_FORMAT";

    print("$in_audio_fn not found\n"), next if not -e $in_audio_fn;
    my $cmd;
    cmd(qq(sox "$in_audio_fn" "$out_audio_fn" trim "$start" "=$end" remix - rate 16k));
}

sub cmd {
    my ($cmd) = @_;
    my $error = system($cmd);
    if ($error) {
        print STDERR "Command failed (#$error): $cmd\n";
        return 0
    }
    return 1
}

