/* data2mat.c
   Jeremy Barnes, 24/8/1999
   $Id$

   This file converts a text file into a MATLAB mat file.  The text file
   contains a number of columns of data.  

   blah

   It links against the MATLAB mat file reading and writing API.

   It also writes a numcategories (=2) and dimensions field to the mat file.
*/

#include "mat.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define mxArray_t mxArray
#define MATFile_t MATFile

#define BUFFER_SIZE 4096
#define WHITESPACE "\t \n\r"

char *argv0;

void figure_out_size(FILE *in_file, int *rows_p, int *cols_p)
     /* This function figures out how many rows and columns of data are
	in the file.  The number of rows is simply the number of lines;
	the number of columns is the maximum number of columns found in
	the file. */
{
    char *buf;
    int rows=0, cols=0;

    /* Rewind the file */
    fseek(in_file, 0, SEEK_SET);

    /* Get our storage buffer */
    buf = malloc(BUFFER_SIZE);
    if (buf == NULL) {
	fprintf(stderr, "%s: unable to allocate %d bytes for buffer\n",
		argv0, BUFFER_SIZE);
	exit(2);
    }

    while (fgets(buf, BUFFER_SIZE, in_file) != NULL) {
	int line_len = 0, is_whitespace, cols_in_line = 0;
	char *p = buf;
	enum { WhiteSpace, Character } state = WhiteSpace;
	
	/* Count the length of this line */
	while ((*p != '\0') && (line_len < BUFFER_SIZE)) {
	    line_len++;
	    p++;
	}

	rows++;

	/* Exit if we truncated it */
	if (line_len >= (BUFFER_SIZE - 1)) {
	    fprintf(stderr, "%s: line %d is too long\n", argv0, rows);
	    exit(3);
	}

	/* What we have here is a state machine, that determines the number
	   of whitespace-character transitions.  Initial conditions are
	   whitespace. */
	p = buf;
	while (*p != '\0') {
	    is_whitespace = ((*p == ' ') || (*p == '\n') || (*p == '\t'));
	    if ((state == WhiteSpace) && !is_whitespace) {
		state = Character;
		cols_in_line++;
	    } else if ((state == Character) && is_whitespace)
		state = WhiteSpace;
	    p++;
	}

	/* Check if this line has more columns than the last */
	if (cols_in_line > cols) cols = cols_in_line;
    }
    
    *cols_p = cols;
    *rows_p = rows;

    free(buf);
}


void read_data(FILE *in_file, mxArray_t *x, mxArray_t *y, int rows, int cols)
     /* This function puts our data into the rows-by-(cols-1) matrix x and
	the rows-by-1 vector y.  File format errors are handled with extreme
	prejudice. */
{
    char *buf;
    double *x_contents, *y_contents;
    int row, col;

    /* Rewind the file */
    fseek(in_file, 0, SEEK_SET);

    /* Get our storage buffer */
    buf = malloc(BUFFER_SIZE);
    if (buf == NULL) {
	fprintf(stderr, "%s: unable to allocate %d bytes for buffer\n",
		argv0, BUFFER_SIZE);
	exit(2);
    }

    /* Ask MATLAB where our data lives */
    x_contents = mxGetPr(x);
    y_contents = mxGetPr(y);

    /* Now do it a line at a time... */
    row = 0;	
    while (fgets(buf, BUFFER_SIZE, in_file) != NULL) {
	int line_len = 0, cols_in_line = 0;
	char *p = buf;
	char *this_token;
        float this_val;
	
	/* Count the length of this line */
	while ((*p != '\0') && (line_len < BUFFER_SIZE)) {
	    line_len++;
	    p++;
	}

	col = 0;

	/* Exit if we truncated it */
	if (line_len >= (BUFFER_SIZE - 1)) {
	    fprintf(stderr, "%s: line %d is too long\n", argv0, row+1);
	    exit(3);
	}

	this_token = strtok(buf, WHITESPACE);

	while (this_token != NULL) {
	    /* Convert token to a string */
	    if (sscanf(this_token, "%f", &this_val) != 1) {
		fprintf(stderr, "%s: invalid token \"%s\" on line %d\n",
			argv0, this_token, row+1);
		exit(3);
	    }

	    /* Assign it */
	    if (col == cols - 1)
		y_contents[row] = (double)this_val;
	    else
		x_contents[col*rows+row] = (double)this_val;
	    col++;

	    this_token = strtok(NULL, WHITESPACE);
	}

	/* If there are less than 2 columns, we certainly can't fill both
	   x and y! */
	if (col < 2) {
	    fprintf(stderr, "%s: short row found in line %d\n", argv0, row+1);
	    exit(3);
	}

	/* If we didn't fill up all rows, the print a warning message, put
	   the last one we found in y, and fill the rest of x with zeros */
	if (col < cols) {
	    int i;
	    fprintf(stderr, "%s: warning: line %d only has %d columns (%d "
		    "expected)\n", argv0, row+1, col, cols);
	    y_contents[row] = x_contents[(col-1)*rows+row];
	    for (i=col-1; i<cols-1; i++)
		x_contents[i*rows+row] = 0.0;
	}

	row++;
    }

    free(buf);
}


void main(int argc, char **argv)
{
    char *in_filename, *out_filename;
    FILE *in_file;
    MATFile_t *out_file;
    int rows, cols;
    mxArray_t *x, *y, *dimensions, *numcategories;

    printf("Text file to MAT file converter version $Version$.\n");
    printf("Copyright Jeremy Barnes, 24/8/1999\n");

    argv0 = argv[0];

    /* Check that we have the right number of arguments... */
    if (argc != 3) {
	fprintf(stderr, "%s: invalid number of arguments (%d)\n", argv[0],
		argc);
	fprintf(stderr, "usage: %s <input_file> <output_file>\n",
		argv[0]);
	exit(1);
    }

    /* Get our filenames */
    in_filename = argv[1];
    out_filename = argv[2];

    printf("Converting %s ==> %s...", in_filename, out_filename);

    /* Check that we can open our input and output files */
    in_file = fopen(in_filename, "r");
    if (in_file == NULL) {
	perror(argv[0]);
	exit(1);
    }

    out_file = matOpen(out_filename, "w");
    if (out_file == NULL) {
	fprintf(stderr, "%s: error opening file %s for output\n",
		argv[0], out_filename);
	exit(1);
    }


    /* Read through the file once to work out how big we want our matrix
       to be */
    figure_out_size(in_file, &rows, &cols);


    /* Create our x and y arrays */
    x = mxCreateDoubleMatrix(rows, cols-1, mxREAL);
    if (x == NULL) {
	fprintf(stderr, "%s: error creating %d by %d matrix x\n",
		argv[0], rows, cols-1);
	exit(2);
    }
    mxSetName(x, "x");

    y = mxCreateDoubleMatrix(rows, 1, mxREAL);
    if (x == NULL) {
	fprintf(stderr, "%s: error creating %d by 1 matrix y\n",
		argv[0], rows);
	exit(2);
    }
    mxSetName(y, "y");


    /* Read through it again, this time getting the data out */
    read_data(in_file, x, y, rows, cols);


    /* Record the number of dimensions */
    dimensions = mxCreateDoubleMatrix(1, 1, mxREAL);
    if (dimensions == NULL) {
	fprintf(stderr, "%s: error creating 1 by 1 matrix dimensions\n",
		argv[0]);
	exit(2);
    }
    *(mxGetPr(dimensions)) = (double)(cols - 1);
    mxSetName(dimensions, "dimensions");


    /* Record the number of categories */
    numcategories = mxCreateDoubleMatrix(1, 1, mxREAL);
    if (numcategories == NULL) {
	fprintf(stderr, "%s: error creating 1 by 1 matrix numcategories\n",
		argv[0]);
	exit(2);
    }
    *(mxGetPr(numcategories)) = 2.0;
    mxSetName(numcategories, "numcategories");


    /* Write our file */
    matPutArray(out_file, x);
    matPutArray(out_file, y);
    matPutArray(out_file, dimensions);
    matPutArray(out_file, numcategories);

    printf(" done.\n");

    /* Clean up */
    mxDestroyArray(x);
    mxDestroyArray(y);
    mxDestroyArray(dimensions);
    mxDestroyArray(numcategories);

    fclose(in_file);
    matClose(out_file);
}
