#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# sort ip 
my @ip = qw(140.116.1.2 140.20.4.3 140.99.7.3 140.3.99.3 140.116.1.3);
my @result = sort {
  my ($a1 , $a2 , $a3 , $a4) = $a =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/;
  my ($b1 , $b2 , $b3 , $b4) = $b =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/;
  $a1 <=> $b1 or $a2 <=> $b2 or $a3 <=> $b3 or $a4 <=> $b4;
} @ip;

print Dumper @result;

# sort hash by keys first and by value second 
my %hash = ("john", 24, "mary", 28, "david", 22, "paul", 28);
my @keysOrder = sort {
  return ($a cmp $b) if ($a cmp $b) != 0;
  return $hash{$a} <=> $hash{$b};
} keys %hash;

print "$_ ".$hash{$_}."\n" for @keysOrder;
