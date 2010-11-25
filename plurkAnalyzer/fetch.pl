#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
use Data::Dumper;
use List::Util qw{min max};
use DBI;
use JSON;

sub load
{
  open FH,"<config.ini" or die "Cant load Config!\n";
  $_ = <FH>;
  close FH;
  return (/(.*?):(.*)/);
}

sub fetch
{
  my $account = shift;
  my $mech = WWW::Mechanize->new();
  my $url  = "http://www.plurk.com/$account";
  $mech->get($url);
  my $result = $mech->content();
  process($result,$account);
}

sub process
{
  my $content = shift;
  my $account = shift;
  my $json = JSON->new->allow_nonref;

  # Get 4 attrs in the table
  my $table = $1 if ($content =~ m{<table>(.*?)</table>}s);

  if(!defined($table))
  {
    return;
  }

  my @attr  = ($table =~ m{<td[^>]*?>(.*?)</td>}sg);

  # Get karma , friends , fans value in GLOBAL
  my $global = $1 if ($content =~ m{var GLOBAL = (.*)});
  $global =~ s/new Date\((.*?)\)/$1/;

  # Use JSON->decode to get the hash ref
  my $ref = $json->decode( $global );

  # Store all results in @final
  my $temp = join(",",@attr[0,1,3,4]);

  # All data
  my $pv        = $attr[0];
  my $karma     = $ref->{page_user}->{karma};
  my $friends   = $ref->{page_user}->{num_of_friends};
  my $fans      = $ref->{page_user}->{num_of_fans};
  my $ffRatio   = (max($friends,$fans) == 0) ? 0 : (min($friends,$fans)/max($friends,$fans))*100;
  my $plurks    = $attr[3];
  my $responses = $attr[4];
  my $prRatio   = (max($plurks,$responses) == 0) ? 0 : (min($plurks,$responses)/max($plurks,$responses))*100;
  my $invited   = $attr[1];

  # Final Result
  my @final = ($pv,$karma,$friends,$fans,$ffRatio,$plurks,$responses,$prRatio,$invited);

  print "$account,";
  print join(",",@final)."\n";
}

my ($account,$password) = load();
my $dbh = DBI->connect('DBI:mysql:plurk;host=localhost',$account,$password) or die("Fail to open mysql");
my $results = $dbh->selectall_hashref('SELECT DISTINCT(`nick_name`) FROM `userInfo` WHERE `uid` != 18757','nick_name');
foreach my $nick (keys %$results)
{
  my $nickName = $results->{$nick}->{nick_name};
  fetch($nickName);
}
#fetch("EragonJ");
