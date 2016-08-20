#!/usr/bin/gawk -f
BEGIN {FS=" ";OFS=""} 
{$1=$1; 
print $0}
