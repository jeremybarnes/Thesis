#!/usr/bin/perl

# wpbc.pl
# Jeremy Barnes, 24/8/1999
# $Id$

# wpbc dataset filter

$data_path = $ARGV[0];

$breast_path = "breast-cancer-wisconsin/";

$wpbc_file = "wpbc.data";


parse_file("$data_path$breast_path$wpbc_file");

sub parse_file {
    $name = $_[0];
    
    open(READ_FILE, $name) || die("Couldn't open $name!");

    $line_num = 1;
    
    # Parse the file
    while ($line = <READ_FILE>) {
	# To do this, strip out ID value at start, change the "M" or "B" at
	# the start to "1" or "0", and put it at the end

	$line =~ s/^([0-9]*),([NR]),([0-9.,]*)/\3,\2/;
	$line =~ tr/,NR/ 01/;

	# Ignore missing lines
	if ($line =~ /\?/) {
	    print STDERR "Ignoring line $line_num with missing value...\n";
	}
	else {
	    print $line;
	}

	$line_num++;
    }
    close(READ_FILE);
}
    
