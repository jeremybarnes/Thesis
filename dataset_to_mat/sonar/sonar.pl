#!/usr/bin/perl

# sonar.pl
# Jeremy Barnes, 24/8/1999
# $Id$

# This file converts the data in the sonar files into plain text which
# can then be converted to a mat file by the text_to_mat program.
# By sonar files, I mean the "sonar" dataset of the UCI ML repository.

$data_path = $ARGV[0];

$sonar_path = "undocumented/connectionist-bench/sonar/";

$mines_file = "sonar.mines";
$rocks_file = "sonar.rocks";

parse_file("$data_path$sonar_path$mines_file", 1);
parse_file("$data_path$sonar_path$rocks_file", 0);

sub parse_file {
    $name = $_[0];
    $value = $_[1];
    
    open(READ_FILE, $name) || die("Couldn't open $name!");
    
    # Parse the file
    while ($line = <READ_FILE>) {
	if ($line =~ /^\{([0-9]*(.)?[0-9]*[\s]+)*[0-9]*(.)?[0-9]*[\s]*$/) {
	    # Start of a record...
	    $line =~ s/\{//;
	    chomp($line);
	    
	    print "$line ";
	    while ($line = <READ_FILE>) {
		# Keep matching until we get to the end
		chomp($line);
		if ($line =~ /.*\}/) {
		    $line =~ s/\}//;
		    print "$line $value\n";
		    last;
		}
		print "$line ";
	    }
	}
    }
    close(READ_FILE);
}
    
