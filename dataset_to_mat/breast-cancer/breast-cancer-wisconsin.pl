#!/usr/bin/perl

# wpbc.pl
# Jeremy Barnes, 24/8/1999
# $Id$

# wpbc dataset filter

$data_path = $ARGV[0];

$path = "breast-cancer-wisconsin/";

$file = "breast-cancer-wisconsin.data";


parse_file("$data_path$path$file");

sub parse_file {
    $name = $_[0];
    
    open(READ_FILE, $name) || die("Couldn't open $name!");

    $line_num = 1;
    
    # Parse the file
    while ($line = <READ_FILE>) {
	# To do this, strip out ID value at start, change the "M" or "B" at
	# the start to "1" or "0", and put it at the end

	chomp($line);

	$line =~ s/^([0-9]*),([0-9.,]*),([42])/\2/;
	$class = $3;
	$class =~ tr/42/01/;
	$line =~ tr/,/ /;

	# Ignore missing lines
	if ($line =~ /\?/) {
	    print STDERR "Ignoring line $line_num with missing value...\n";
	}
	else {
	    print "$line $class\n";
	}

	$line_num++;
    }
    close(READ_FILE);
}
    
