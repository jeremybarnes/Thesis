/* findmax.c
 * Jeremy Barnes, 2/11/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that finds the maximum
 * element of each row of a matrix and returns an index to it.
 * 
 * See the file findmax.m for full details.
 *
 * MATLAB syntax:
 *
 * function m = findmax(a)
 *
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>

/* Calculation function */
void do_findmax(double *a, double *m, int rows, int cols)
{
    /* We temporarily store the maximum values in m and the indexes in
       mi.  We then swap them over at the end. */

    int *mi;
    int i, j;
    double *p;

    mi = mxCalloc(rows, sizeof(int));
    if (mi == NULL) mexErrMsgTxt("findmax: out of memory");

    /* Fill it in with the first column */
    for (i=0; i<rows; i++) {
	m[i] = a[i];
	mi[i] = 1;
    }

    p = a + rows;

    /* Now repeat for the rest of the columns */
    for (i=1; i<cols; i++) {
	for (j=0; j<rows; j++) {	
	    if (*p > m[j]) {
		m[j] = *p;
		mi[j] = i+1;
	    }
	    p++;
	}
    }

    /* Put mi into m */
    for (i=0; i<rows; i++)
	m[i] = (double)mi[i];
    
    /* Clean up */
    mxFree(mi);
}
		


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double *m, *a;
    int rows, cols;

    a = mxGetPr(prhs[1]);
    rows = mxGetM(prhs[1]);
    cols = mxGetN(prhs[1]);

    /* Create our output matrix */
    plhs[0] = mxCreateDoubleMatrix(rows, 1, mxREAL);
    m = mxGetPr(plhs[0]);

    /* Perform the classification */
    do_findmax(a, m, rows, cols);

}


