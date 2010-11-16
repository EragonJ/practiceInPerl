#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
my $platform = `uname`;
my $code = $ARGV[0] || "test";
my %postFields = (
  lang => "text",
  description => "",
  code => $code,
  parent => 0
);
$mech->post("http://paste2.org/new-paste",\%postFields);

# Set the link and copy command
my $link = "http://paste2.org/p/$1" if ($mech->content() =~ m{<link rel='stylesheet'.*href='/style/(.*?).css'});
my $copy = ($platform =~ /Darwin/) ? "pbcopy" :  "xclip -selection clipboard";

# Final , print the link and store it in the clipboard
print $link;
`echo $link | $copy`;
