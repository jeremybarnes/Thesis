/* matlabscript.c
   Jeremy Barnes, 24/8/1999
   $Id$

   This file executes the named MATLAB script from the command line.

   LICENSE:

   Copyright (C) 1999 Jeremy Barnes

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include "getopt.h"

#include "mat.h"
#include "engine.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

#define mxArray_t mxArray
#define MATFile_t MATFile
#define Engine_t Engine

#define DEFAULT_OUTPUT_BUFFER_SIZE 65536
#define MAX_LINE_LENGTH 4096

/* Exit codes */
#define EXIT_OK 0
#define EXIT_INVALID_ARG 1
#define EXIT_NO_MEMORY 2
#define EXIT_CANT_OPEN_FILE 3
#define EXIT_COULDNT_CONNECT_TO_MATLAB 4
#define EXIT_MATLAB_SHUTDOWN 5
#define EXIT_INTERNAL_ERROR 6
#define EXIT_LINE_TOO_LONG 7

char *argv0;

int banner_printed = 0;
int no_license_text = 0;

void print_banner();

void exit_with_error(int code, const char *format, ...)
{
    va_list ap;

    print_banner();
    va_start(ap, format);
    fprintf(stderr, "%s: ", argv0);
    vfprintf(stderr, format, ap);
    exit(code);
}

void print_banner()
{
    if (!banner_printed) {
	printf("matlabscript: a command line MATLAB script executor\n");
	printf("Copyright (C) 1999 Jeremy Barnes\n");
	if (!no_license_text)
	    printf("Please run `%s --license' for the license agreement\n",
		   argv0);
	banner_printed = 1;
    }
}

void print_version()
{
    print_banner();
    printf("$Id$\n", argv0);
}

void print_help()
{
    static char help_text[] =
#include "help_text.c"
;

    print_banner();
    printf("\n%s\n", help_text);
}

void print_license()
{
    static char license_text[] =
#include "license_text.c"
;

    print_banner();
    printf("\n%s\n", license_text);
}

/* Enum to tell us whether to run literally or execute the file line by line */
enum command_type { RunCommand, RunFile };

/* Linked list in which to hold a list of commands to run */
struct command {
    enum command_type type;
    char *command_str;
    struct command *next;
};

/* This is where we store the results of our getopt */
static char null_options[] = "\0";

int be_quiet = 0;
int be_verbose = 0;
int dont_print_commands = 0;
int debug = 0;
int output_buffer_size = DEFAULT_OUTPUT_BUFFER_SIZE;
struct command *command_list = NULL;
char *engine_options = null_options;

/* The possible options... */
static struct option long_options[] =
{
    {"quiet", 0, &be_quiet, 1},
    {"verbose", 0, &be_verbose, 1},
    {"debug", 0, &debug, 1},
    {"output-buffer-size", 1, 0, 'b'},
    {"help", 0, 0, 'h'},
    {"version", 0, 0, 'v'},
    {"license", 0, 0, 'l'},
    {"run-file", 1, 0, 'f'},
    {"run-command", 1, 0, 'c'},
    {"engine-options", 1, 0, 'o'},
    {"dont-print-commands", 0, &dont_print_commands, 1},
    {0, 0, 0, 0}
};

void do_options(int argc, char **argv)
{
    int c;
    struct command *last_command = NULL, *new_command;
        
    for (;;) {
	/* getopt_long  stores the option index here. */
	int option_index = 0;
	int res, val;
        
	c = getopt_long (argc, argv, "qb:hvlf:c:o:VdC",
			 long_options, &option_index);
        
	/* Detect the end of the options. */
	if (c == -1)
	    break;
        
	switch (c) {
	case 0:
	    /* If this option set a flag, do nothing else now. */
	    break;
        
	case 'q':
	    be_quiet = 1;
	    break;
        
	case 'b':
	    res = sscanf(optarg, "%d", &val);
	    if (res == 0) {
		fprintf(stderr, "%s: Invalid buffer size %s",
			argv[0], optarg);
		exit(1);
	    }
	    output_buffer_size = val;
	    break;

	case 'V':
	    be_verbose = 1;
	    break;

	case 'Q':
	    dont_print_commands = 1;
	    break;

	case 'd':
	    debug = 1;
	    break;
        
	case 'h':
	    print_help();
	    exit(0);
	    break;
        
	case 'v':
	    print_version();
	    exit(0);
	    break;

	case 'l':
	    no_license_text = 1;
	    print_license();
	    exit(0);
	    break;

	case 'f':
	case 'c':
	    /* Run a command or a file */
	    new_command = malloc(sizeof(struct command));
	    if (new_command == NULL)
		exit_with_error(EXIT_NO_MEMORY, 
				"no memory to allocate for command\n");

	    /* Add this command struct to the end of the list */
	    if (last_command == NULL)
		command_list = new_command;
	    else
		last_command -> next = new_command;
		    
	    if (c == 'f') {
		new_command -> type = RunFile;
		if (debug)
		    printf("New file: %s\n", optarg);
	    }
	    else {
		new_command -> type = RunCommand;
		if (debug) {
		    printf("New command: %s\n", optarg);
		}
	    }

	    new_command -> command_str = optarg;
	    new_command -> next = NULL;
		    
	    last_command = new_command;
	    break;
        
	case 'o':
	    engine_options = optarg;
	    break;

	case '?':
	    /* getopt_long  already printed an error message. */
	    exit(EXIT_INVALID_ARG);
	    break;
        
	default:
	    abort ();
	}	
    }		
        
    /* Any remaining command line arguments are commands to run */
    while (optind < argc) {

	new_command = malloc(sizeof(struct command));
	if (new_command == NULL)
	    exit_with_error(EXIT_NO_MEMORY, 
			    "no memory to allocate for command\n");
	
	/* Add this command struct to the end of the list */
	if (last_command == NULL) 
	    command_list = new_command;
	else	
	    last_command -> next = new_command;
	
	new_command -> type = RunCommand;
	new_command -> command_str = argv[optind];
	new_command -> next = NULL;
	if (debug) fprintf(stderr, "New command: %s\n", argv[optind]);

	last_command = new_command;
	optind++;
    }

    if (debug)
	be_verbose == 1;
}


static int engine_running = 0;
char *output_buffer;
Engine_t *eng;


int is_whitespace(char c)
{
    return ((c == ' ') || (c == '\n') || (c == '\r') || (c == '\t'));
}


void run_command(char *command_name)
{
    int res;
    char *start_command;
    int len;

    /* Strip off whitespace from the front and back */
    len = strlen(command_name);
    start_command = command_name;
    while ((is_whitespace(*start_command) && (len > 0))) {
	start_command++;
	len--;
    }	
	
    while ((is_whitespace(start_command[len-1])) && (len > 0)) {
	start_command[len-1] = '\0';
	len--;
    }

    /* Don't execute the empty command */
    if (len == 0) return;

    /* Make sure that we can execute the command */
    if (!engine_running)
	exit_with_error(EXIT_MATLAB_SHUTDOWN, 
			"MATLAB engine was shutdown by command before %s\n",
			command_name);

    /* Clear output buffer of garbage */
    memset(output_buffer, '\0', output_buffer_size);

    /* Execute it */
    if (!be_quiet && !dont_print_commands) printf(">> %s\n", command_name);
    res = engEvalString(eng, command_name);

    if (res == 0)
	engine_running = 1;
    else
	engine_running = 0;

    /* Print out the output (unless we want it supressed) */
    if (!be_quiet)
	printf("%s\n", output_buffer);
}


void run_file(const char *filename)
{
    FILE *in_file;
    char buf[MAX_LINE_LENGTH];
    int line_num;

    if (debug || be_verbose)
	fprintf(stderr, "Opening file %s for commands...\n", filename);

    /* Check that we can open our input file */
    in_file = fopen(filename, "r");
    if (in_file == NULL) {
	print_banner();
	perror(argv0);
	exit(EXIT_CANT_OPEN_FILE);
    }

    line_num = 0;

    /* Read it a line at a time */
    while (fgets(buf, MAX_LINE_LENGTH, in_file) != NULL) {
	int line_len = 0;
	char *p = buf;

	line_num++;
	
	/* Count the length of this line */
	while ((*p != '\0') && (line_len < MAX_LINE_LENGTH)) {
	    line_len++;
	    p++;
	}

	/* Exit if we truncated it */
	if (line_len >= (MAX_LINE_LENGTH - 1))
	    exit_with_error(EXIT_LINE_TOO_LONG, "line %d of %s is too long\n",
			    line_num, filename);

	/* Ignore lines that start with '#' or with '%' */
	if ((buf[0] == '%') || (buf[0] == '#'))
	    continue;
	
	/* Execute the particular line */
	run_command(buf);
    }
}


void main(int argc, char **argv)
{
    struct command *this_command;

    argv0 = argv[0];

    if (debug || be_verbose) print_banner();

    if (debug) fprintf(stderr, "Processing options...\n");

    do_options(argc, argv);

    if (command_list == NULL) exit_with_error(EXIT_OK, "nothing to do\n");

    if (debug || be_verbose) fprintf(stderr, 
				     "Connecting to MATLAB engine...\n");

    /* Open/link to the MATLAB engine */
    eng = engOpen(engine_options);
    if (eng == NULL) exit_with_error(EXIT_COULDNT_CONNECT_TO_MATLAB,
				     "unable to connect to MATLAB engine\n");
    engine_running = 1;

    /* Get a buffer to store MATLAB's output in */
    output_buffer = malloc(output_buffer_size);
    if (output_buffer == NULL)
	exit_with_error(EXIT_NO_MEMORY,
			"unable to allocate %d bytes for output buffer\n",
			output_buffer_size);

    /* Connect up to the output buffer */
    if (!be_quiet)
	engOutputBuffer(eng, output_buffer, output_buffer_size);

    /* Execute commands or files, one by one */
    this_command = command_list;
    while (this_command != NULL) {
	switch (this_command -> type)
	    {		       
	    case RunCommand:
		run_command(this_command -> command_str);
		break;
	    case RunFile:
		run_file(this_command -> command_str);
		break;
	    default:
		exit_with_error(EXIT_INTERNAL_ERROR,
				"internal error: invalid command enum %d\n",
				this_command -> type);
	    }	
	
	this_command = this_command -> next;
    }

    /* Clean up linked list */
    this_command = command_list;
    while (this_command != NULL) {
	struct command *next_command = this_command -> next;
	free(this_command);
	this_command = next_command;
    }

    /* Stop MATLAB engine */
    if (engine_running) engClose(eng);

    /* Free our output buffer */
    free(output_buffer);
}
