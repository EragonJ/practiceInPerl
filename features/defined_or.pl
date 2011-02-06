#!/usr/bin/perl -w
use strict;
sub hello_world
{
  my $name = shift // 'Jack';
  print "$name says 'Hello world'.\n";
}

hello_world(); # Jack says ... blah
hello_world('Jenny'); # Jenny says ... blah

# defined-or mechanism sometimes is more useful than boolean-or
sub fake_hello_world 
{
  my $name = shift || 'Jack';
  print "$name says 'Hello world'.\n";
}

fake_hello_world(); # Jack says ... blah 
fake_hello_world('0'); # still Jack says ... blah , but this guy's name is '0' ( Perl's magin - coercion )
