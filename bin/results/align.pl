#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use lib 'lib';
use lib "$ENV{EDHome}/lib";
use MakonFM;
use MakonFM::Util::Vyslov;
use MakonFM::Model::DB;
use MakonFM::Util::MatchChunk;
use File::Basename qw(dirname);
use Data::Dumper;

my $dsasrdir = (sub { dirname((caller)[1]) }->()) . '/../..';

my ($stem, $trans_fn, $from, $to) = @ARGV;
my $mfccdir = $ENV{MFCC_DIR} or die 'set env MFCC_DIR';
my $mfcc_fn = "$mfccdir/$stem.mfcc";
die "mfcc $mfcc_fn not readable" if not -r $mfcc_fn;

eval {
    my $db = MakonFM::Model::DB->new;
    MakonFM::Util::Vyslov::set_dict($db->resultset('Dict'));
};

my $matched = MakonFM::Util::MatchChunk::get_subs(
    $trans_fn, $mfcc_fn, $from, $to,
);

if ($matched->{success}) {
    print(
        join ",\n", map JSON::XS->new->pretty->encode($_), @{ $matched->{data} }
    );
}
