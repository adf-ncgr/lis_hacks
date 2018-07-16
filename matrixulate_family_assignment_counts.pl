#!/usr/bin/env perl
use strict;
use Getopt::Long;
my $family_build="phytozome_10_2";
my $description_contains;

GetOptions(
	"family_build=s" => \$family_build,
	"description_contains=s" => \$description_contains,
);
my %gf2desc;
open(GFD, "gene_family_descriptors") || die $!;
while (<GFD>) {
    chomp;
    my ($gf, $desc) = split /\t/;
    $gf =~ s/^$family_build\.//;
    $gf2desc{$gf} = $desc;
}
close GFD;

my %matrix;
foreach my $gf_assignment_file (@ARGV) {
    open(F, $gf_assignment_file) || die $!;
    while (<F>) {
        chomp;
        my (undef, $gf, undef) = split /\t/;
        $gf =~ s/^$family_build\.//;
        $matrix{$gf}->{$gf_assignment_file}++;
        $matrix{$gf}->{total_counts}++;
    }
    close F;
}

my %total_counts;
print join("\t", "family", "description", @ARGV), "\n";
foreach my $gf (sort {$matrix{$b}->{total_counts} <=> $matrix{$a}->{total_counts}} keys %matrix) {
    if ((! defined $description_contains) || $gf2desc{$gf} =~ /$description_contains/) {
        print join("\t", $gf, $gf2desc{$gf}, (map {my $count = ($matrix{$gf}->{$_} ? $matrix{$gf}->{$_} : 0); $total_counts{$_} += $count; $count;} @ARGV)), "\n";
    }
}
print join("\t", "TOTALs", "", map {$total_counts{$_};} @ARGV);	
