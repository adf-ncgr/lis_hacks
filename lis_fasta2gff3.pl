#!/usr/bin/env perl

use strict;
use English;
$RS="\n>";
$ORS="\n";
$OFS="\t";
use Getopt::Long;
my $prefix;
my $source = ".";
my $type="supercontig";
#TODO: allow sequences to be written in the output
GetOptions(
    "prefix=s" => \$prefix,
    "source=s" => \$source,
    "type=s" => \$type,
);
print "##gff-version 3";
while (<>) {
    chomp;
    s/^>//;
    my ($id, $seq) = /(\S+)[^\n]*\n(.*)/s;
    $seq =~ s/\n//g;
    if (defined $prefix) {
        $id = $prefix.$id;
    }
    print $id, $source, $type, 1, length($seq), ".", ".", ".", "ID=$id;Name=$id";
}
