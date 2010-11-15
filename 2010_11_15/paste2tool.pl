#!/usr/bin/perl -w
# I have to fix chinese words problems in $ARGV and try to utilize it with long sentences input
use strict;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
my $code = $ARGV[1] || "test";
my %postFields = (
  lang => "text",
  description => "",
  code => $code,
  parent => 0
);
$mech->post("http://paste2.org/new-paste",\%postFields);
my $link = $1 if ($mech->content() =~ m{<link rel='stylesheet'.*href='/style/(.*?).css'});
print "http://paste2.org/p/$link\n";
