package Asciize;
use strict;
use warnings;
use utf8;
use Exporter qw(import);

our @EXPORT_OK = qw(asciize);

our %map = (
    'á' => 'a',
    'é' => 'e',
    'í' => 'i',
    'ó' => 'o',
    'ú' => 'u',
    'ý' => 'y',
    'č' => 'c',
    'ď' => 'd',
    'ě' => 'j',
    'ň' => 'n',
    'ř' => 'r',
    'š' => 's',
    'ť' => 't',
    'ů' => 'w',
    'ž' => 'z',
);

sub asciize {
    s/([áéíóúýčďěňřšťůž])/'$map{$1}/g for @_;
}

1;

__END__
