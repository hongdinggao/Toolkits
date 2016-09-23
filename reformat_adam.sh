#!/bin/bash
#------------------------------------------------------------------------------------
# By default, OpenMP and multi-threaded MKL will use
# all cores in a node
#
# For running OpenMP jobs, the procedure is similar as for MPI jobs
# means nodes=1
#------------------------------------------------------------------------------------


##PBS -l nodes=1
#PBS -N reformat
#PBS -q gbi-short
#PBS -l walltime=1:00:00
##PBS -l nodes=1:ppn=8
#PBS -j oe


JOBNAME=mk_adam
MKFILE=/usr/home/qgg/hdg/ADAM2016/hongding/marker1.res
#PROG=
TMPDIR=/scratch/$USER/$PBS_JOBID
out=$PBS_O_WORKDIR/$JOBNAME.lst


echo "Reformat the marker file from ADAM                              $(date +"%H:%M %A, %B %d, %Y")" >  $out
echo                                                                                 >> $out
echo                                                                                 >> $out
echo "The host name for job:         $HOSTNAME"                                      >> $out
echo "PBS_O_WORKDIR:                 $PBS_O_WORKDIR"                                 >> $out
echo "TMPDIR:                        $TMPDIR"                                        >> $out
echo "out:                           $out"                                           >> $out
echo                                                                                 >> $out
echo                                                                                 >> $out

cd $PBS_O_WORKDIR

#export OMP_NUM_THREADS=8


cp $MKFILE $TMPDIR/

cd $TMPDIR

ulimit -s unlimited

# 2 represents standard error, 1 represents standard out
# redirect both stdout and stderr to the same location
start=`date +%s`
FIRSTLINE=$(nl marker1.res | grep "1 0   1" | awk '{print $1}' | head -n1)
echo "The start line for markers is from $FIRSTLINE"                          >> $out       


# extract the markers
awk -v ss=$FIRSTLINE 'NR >= ss' marker1.res > mk.tmp


# print all but not the last 2 lines
head -n -2 mk.tmp > mk.tmp2

echo                                                                              >> $out
echo "The Nr. after extract the original ADAM marker file is $(wc -l < mk.tmp2)"  >> $out

rm marker1.res mk.tmp

# Nr of individuals
nchro=30
nnl=$(wc -l < mk.tmp2)
#nanimals=$(echo "scale=0; $nnl/$nchro" | bc -l)
nanimals=$(expr $nnl / $nchro)
echo "The Nr. of animals is $nanimals "                                        >> $out


# check the Nr. of loci in each chromosome
head -$nchro mk.tmp2 | awk '{SUM += length($4)/2; print "the Nr of markers in chromosome ", NR, " is ", length($4)/2} END {print "The Nr. of loci is ", SUM}' >> $out



#(  $PROG < par.txt ) >> $out 2>&1
end=`date +%s`
runtime=$(echo "($end-$start)/3600" | bc -l)
echo " The running time for the program:      ${runtime} hr "                 >> $out

#cp GEBV.txt $PBS_O_WORKDIR/
