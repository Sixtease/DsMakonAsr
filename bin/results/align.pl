#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use lib 'lib';
use lib "$ENV{EDHome}/lib";
use HTKUtil::MfccLib qw(mfcc_header);
use MakonFM;
use MakonFM::Util::Vyslov;
use MakonFM::Model::DB;
use MakonFM::Util::MatchChunk;
use File::Basename qw(dirname);

my $dsasrdir = (sub { dirname((caller)[1]) }->()) . '/../..';

my ($stem) = @ARGV;
my $mfccdir = $ENV{MFCC_DIR} or die 'set env MFCC_DIR';
my $mfcc_fn = "$mfccdir/$stem.mfcc";
die "mfcc $mfcc_fn not readable" if not -r $mfcc_fn;
my $mfcc_header = mfcc_header($mfcc_fn);

my $trans_fn = "$dsasrdir/data/recout/utf8/$stem.txt";

eval {
    my $db = MakonFM::Model::DB->new;
    MakonFM::Util::Vyslov::set_dict($db->resultset('Dict'));
};

my $matched = MakonFM::Util::MatchChunk::get_subs(
    $trans_fn, $mfcc_fn, 0, $mfcc_header->{length},
);

if ($matched->{success}) {
    print(
        qq|jsonp_subtitles({ "filestem": "$stem", "data":|,
        JSON::XS->new->pretty->encode($matched->{data}),
        "});\n",
    );
}
