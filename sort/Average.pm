package Average;
sub avg
{
  my $total = 0;
  $total += $_ for @_;
  $total / +@_; 
}
1;
