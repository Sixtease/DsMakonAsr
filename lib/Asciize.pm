package Asciize;
use strict;
use warnings;
use utf8;
use Exporter qw(import);

our @EXPORT_OK = qw(asciize deasciize);

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

our %rmap = (
    'a' => 'á',
    'e' => 'é',
    'i' => 'í',
    'o' => 'ó',
    'u' => 'ú',
    'y' => 'ý',
    'c' => 'č',
    'd' => 'ď',
    'j' => 'ě',
    'n' => 'ň',
    'r' => 'ř',
    's' => 'š',
    't' => 'ť',
    'w' => 'ů',
    'z' => 'ž',
);

sub asciize {
    s/([áéíóúýčďěňřšťůž])/'$map{$1}/g for @_;
}

sub deasciize {
    s/'([aeiouycdjnrstwz])/$rmap{$1}/g for @_;
}

1;

__END__
