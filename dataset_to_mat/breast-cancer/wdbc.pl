#!/usr/bin/perl

# wdbc.pl
# Jeremy Barnes, 24/8/1999
# $Id$

# wdbc dataset filter

$data_path = $ARGV[0];

$breast_path = "breast-cancer-wisconsin/";

$wdbc_file = "wdbc.data";


parse_file("$data_path$breast_path$wdbc_file");

sub parse_file {
    $name = $_[0];
    
    open(READ_FILE, $name) || die("Couldn't open $name!");
    
    # Parse the file
    while ($line = <READ_FILE>) {
	# To do this, strip out ID value at start, change the "M" or "B" at
	# the start to "1" or "0", and put it at the end

	$line =~ s/^([0-9]*),([MB]),([0-9.,]*)/\3,\2/;
	$line =~ tr/,MB/ 01/;
	print $line;
    }
    close(READ_FILE);
}
    
