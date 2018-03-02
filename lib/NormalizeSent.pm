#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use utf8;
use Exporter qw(import);

our @EXPORT_OK = qw(load_alphabet normalize);

sub load_alphabet {
    my $alphabet = do {{
        open my $alphabet_fh, '<:utf8', $ENV{WIDE_ALPHABET_FN} or die "could not open alphabet file $ENV{WIDE_ALPHABET_FN}: $!";
        my @chars = <$alphabet_fh>;
        chomp for @chars;
        join('', @chars);
    }};
    return $alphabet;
}

my $static_alphabet;

sub normalize {
    my ($sent, $alphabet) = @_;
    if (not defined $alphabet) {
        if (not defined $static_alphabet) {
            $static_alphabet = load_alphabet();
        }
        $alphabet = $static_alphabet;
    }
    (my $normalized = lc $sent) =~ s/[^$alphabet]//g;
    return $normalized;
}

1;

__END__
