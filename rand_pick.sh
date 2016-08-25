#!/bin/bash
#------------------------------------------------------------------------------
#  A shell script which can randomly extract number of lines from a data file
#  Run using: ./rand_pick.sh originalfile number  > resultsfile
#  For example:         ./rand_pick.sh big.txt 50 > small.txt
#
#  by Hongding Gao  Aug. 19, 2016
#------------------------------------------------------------------------------

ll=`wc -l < $1`
ff=$1               # original filename
nn=$2               # Nr. of lines needs to be extracted
#echo $ll

awk -v max="$ll" -v total=$nn '
BEGIN {
   srand();
    for (i=1; i<=total; i++) {
        rnd = int(rand()*max+0.5);   # between 1-max randdom number 
        if (rnd in arr) {
            i--;
        } else {
#            print rnd;
            arr[rnd];               # store the index in the array and set the value to null string
        } 
    }
}
{
   if (NR in arr) print $0;
}
' $ff



