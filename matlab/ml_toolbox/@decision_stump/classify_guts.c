/* @decision_stump/classify_guts.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * performs the classification of a decision stump.
 *
 * Hopefully, some day I will be able to use this code to speed up CART
 * as well...
 *
 * MATLAB syntax:
 *
 * function y = classify_guts(obj, x, var, val, leftcat, rightcat)
 *
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>

/* Calculation function */
void do_classify(double *x, double *y, int var, double val, int leftcat,
		 int rightcat, int data_len)
{
    double left, right, *px, *py, v;
    double y1, y2;
    double x1, x2;
    int i;

    left = (double)leftcat;
    right = (double)rightcat;
    
    /* Point at the correct column */
    px = x + (var-1)*data_len;

    py = y;

    v = val;

    /* Pre-loop initialisation */
    x1 = *px++;
    x2 = *px++;

    data_len -= 2;

    for (i=0; i<data_len; i+=2) { /* 2-way loop unrolled */
	if (x1 <= v)
	    *py++ = left;
	else
	    *py++ = right;

	x1 = *px++;

	if (x2 <= v)
	    *py++ = left;
	else
	    *py++ = right;

	x2 = *px++;
    }

    /* Post-loop cleanup */
    if (x1 <= v)
	y1 = left;
    else
	y1 = right;

    *py++ = y1;

    if (x2 <= v)
	y2 = left;
    else
	y2 = right;

    *py++ = y2;

}
		


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* First argument, obj, is ignored */
     
    double *x, *y, val;
    int var, leftcat, rightcat, data_len;

    x = mxGetPr(prhs[1]);
    var = (int)mxGetScalar(prhs[2]);
    val = mxGetScalar(prhs[3]);
    leftcat = (int)mxGetScalar(prhs[4]);
    rightcat = (int)mxGetScalar(prhs[5]);
    data_len = mxGetM(prhs[1]);

    /* Create our output matrix */
    plhs[0] = mxCreateDoubleMatrix(data_len, 1, mxREAL);
    y = mxGetPr(plhs[0]);

    /* Perform the classification */
    do_classify(x, y, var, val, leftcat, rightcat, data_len);

}


/* @decision_stump/classify_guts.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * performs the classification of a decision stump.
 *
 * Hopefully, some day I will be able to use this code to speed up CART
 * as well...
 *
 * MATLAB syntax:
 *
 * function y = classify_guts(obj, x, var, val, leftcat, rightcat)
 *
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>

/* Calculation function */
void do_classify(double *x, double *y, int var, double val, int leftcat,
		 int rightcat, int data_len)
{
    double left, right, *px, *py, v;
    int i;

    left = (double)leftcat;
    right = (double)rightcat;
    
    /* Point at the correct column */
    px = x + (var-1)*data_len;

    py = y;

    v = val;

    for (i=0; i<data_len; i++) {
	if (*px++ <= v)
	    *py++ = left;
	else
	    *py++ = right;
    }
}
		


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* First argument, obj, is ignored */
     
    double *x, *y, val;
    int var, leftcat, rightcat, data_len;

    x = mxGetPr(prhs[1]);
    var = (int)mxGetScalar(prhs[2]);
    val = mxGetScalar(prhs[3]);
    leftcat = (int)mxGetScalar(prhs[4]);
    rightcat = (int)mxGetScalar(prhs[5]);
    data_len = mxGetM(prhs[1]);

    /* Create our output matrix */
    plhs[0] = mxCreateDoubleMatrix(data_len, 1, mxREAL);
    y = mxGetPr(plhs[0]);

    /* Perform the classification */
    do_classify(x, y, var, val, leftcat, rightcat, data_len);

}


