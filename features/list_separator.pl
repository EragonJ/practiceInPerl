#!/usr/bin/perl -w
use strict;
use English; # use English.pm for readable variable names

my @ar = (1..5);
{
    # use readable variable name $LIST_SEPARATOR
    # local $LIST_SEPARATOR = ')(';  
    local $" = ')(';
    print "(@ar)\n"; # in double quote , it will make the list into interpolation mode
    # result (1)(2)(3)(4)(5)
}

print "@ar";
# result 1 2 3 4 5
