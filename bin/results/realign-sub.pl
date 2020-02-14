#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use JSON::XS ();
use File::Basename qw(dirname);
use Encode qw(encode_utf8);
my $PATH;
BEGIN { $PATH = sub { dirname((caller)[1]) }->() . '/../..' }
use lib "$PATH/../asr/lib";
use lib "$PATH/lib";
use lib "lib";
use lib "$ENV{EDHome}/lib";
use HTKUtil::MfccLib qw(mfcc_header);
use MakonFM;
use MakonFM::Util::Vyslov;
use MakonFM::Model::DB;
use MakonFM::Util::MatchChunk;
use Subs qw(decode_subs encode_subs);

my $SECOND = 1;
my $MINUTE = 60 * $SECOND;
my $CHUNK_SIZE = 5 * $SECOND;

my $dsasrdir = (sub { dirname((caller)[1]) }->()) . '/../..';

my ($stem) = @ARGV;
my $mfccdir = $ENV{MFCC_DIR} or die 'set env MFCC_DIR';
my $mfcc_fn = "$mfccdir/$stem.mfcc";
die "mfcc $mfcc_fn not readable" if not -r $mfcc_fn;
my $mfcc_header = mfcc_header($mfcc_fn);

my $subdir = $ENV{MAKONFM_SUB_DIR} or die 'set env MAKONFM_SUB_DIR';
my $sub_fn = "$subdir/$stem.sub.js";
die "sub $sub_fn not readable" if not -r $sub_fn;

my $subs = decode_subs($sub_fn);

eval {
    my $db = MakonFM::Model::DB->new;
    MakonFM::Util::Vyslov::set_dict($db->resultset('Dict'));
};

my $buf_start = $subs->{data}[0]{timestamp};
my @wbuf;
my @sbuf;
my $last_timestamp = 0;
for my $word (@{ $subs->{data} }, {timestamp => $mfcc_header->{length}, is_padding => 1}) {
    delete $word->{sstart};
    if ($word->{timestamp} < $last_timestamp) {
        die "decreasing timestamp, quitting $stem";
    }
    $last_timestamp = $word->{timestamp};
    if ($word->{timestamp} - $buf_start > $CHUNK_SIZE or $word->{is_padding}) {
        my $trans = join(' ', map $_->{occurrence}, @wbuf);
        my $trans_octets = encode_utf8($trans);

        my $matched = MakonFM::Util::MatchChunk::get_subs(
            \$trans_octets, $mfcc_fn, $buf_start, $word->{timestamp},
        );

        $buf_start = $word->{timestamp};

        if ($matched->{success}) {
            push @sbuf, @{ $matched->{data} };
        }
        else {
            push @sbuf, @wbuf;
        }

        @wbuf = ();
    }
    push @wbuf, $word;
}

print encode_subs(\@sbuf, $subs->{filestem});
