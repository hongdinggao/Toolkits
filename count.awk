BEGIN {
    count=0;    # it is not necessary as undefined variables have the default value 0
}
{
    if ($4 ~ /Technology/) {
	count++;
        sum += $1;
    }
}
END {
    print "Nr. of employee in Dept. Technology is ", count;
    print "The total Nr. of records is ", NR;
    print "All salary in this dept. is ", sum;
    print "The file i am dealing with is ", FILENAME;
}