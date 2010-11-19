#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
my $code;

# It means we have many files to load
if(scalar(@ARGV)>0)
{
  for my $filename (@ARGV)
  {
    # Open all files and store in $code
    {
      local $/ = undef; 
      local *FILE; 
      open FILE, "<$filename"; 
      $code .= <FILE>."\n"; 
      close FILE; 
    }
  }
  $code .= "This file is generated automatically by paste2tool!";
}
else
{
  print "Type something by yourself.\n> ";
  $code = <>;
}

my %postFields = (
  lang => "text",
  description => "",
  code => $code,
  parent => 0
);
$mech->post("http://paste2.org/new-paste",\%postFields);

my $platform = `uname`;
# Set the link and copy command
my $link = "http://paste2.org/p/$1" if ($mech->content() =~ m{<link rel='stylesheet'.*href='/style/(.*?).css'});
my $copy = ($platform =~ /Darwin/) ? "pbcopy" :  "xclip -selection clipboard";

# Final , print the link and store it in the clipboard
print "$link\n";
`echo $link | $copy`;