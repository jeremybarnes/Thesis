/* @decision_stump/train_guts.c
 * Jeremy Barnes, 16/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * performs the training of a decision stump.
 *
 * Hopefully, some day I will be able to use this code to speed up CART
 * as well...
 *
 * MATLAB syntax:
 *
 * function [var, val, left_cat, right_cat] = 
 *            train_guts(obj, x, y, w, dimensions, cat);
 *
 * This file includes code from the GNU C library, and for this reason
 * is under the GNU General Public License.
 *
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>

/* Holds an (x, y, w) triple to allow sorting */
struct xyw {
    double x;
    int y;
    double w;
};

int compare(const void *arg1, const void *arg2)
/* Compare two struct xyw's, and return -1, 0 or +1 depending upon which
 * is larger.
 */
{
    if ((*(struct xyw *) arg1).x >= (*(struct xyw *) arg2).x)
	return 1;
    else
	return -1;
}

void category_weight(struct xyw *xyw, int cat, int data_len, double *weights);

/* Calculation function */
/* ASSUMPTION : No element of w is zero (or we will get divide by zero) */
void optimal_split(double *x, int *y, double *w, int dimensions, 
		   int data_length, int cat, int *var, double *val,
		   int *left_cat, int *right_cat)
{
    int i, j, k;

    double best_Q = mxGetInf();

    double this_w;
    int this_y;
    double w_sum, left_sum, *left_total, right_sum, *right_total;
    double *xp, *wp;
    int *yp;

    struct xyw *xyw;
    int left_index, right_index;

    int tmp_var, tmp_left, tmp_right;
    double tmp_val, left_max, right_max, Qleft, Qright, this_Q;


    /* Allocate memory */
    xyw = mxCalloc(data_length, sizeof(struct xyw));
    left_total = mxCalloc(cat, sizeof(double));
    right_total = mxCalloc(cat, sizeof(double));

    *var = 1;
    *val = 0.5;
    *left_cat = 0;
    *right_cat = 1;

    for (i=0; i<dimensions; i++) {

	/*	mexPrintf("dimension %d\n", i); */
	
	xp = x + (i*data_length);
	yp = y;
	wp = w;
	
	/* Copy data into our array */
	for (j=0; j<data_length; j++) {
	    xyw[j].x = *xp++;
	    xyw[j].y = *yp++;
	    /*	    mexPrintf("y = %d\n", *(yp - 1)); */
	    xyw[j].w = *wp++;
	}
	
	/* sort ALL of the data on the x value */
	qsort((void *)xyw, data_length, sizeof(struct xyw), compare);

	/* calculate sum of w values */
	w_sum = 0.0;
	for (j=0; j<data_length; j++) {
	    w_sum += w[j];
	}

	/* Initialise variables */
	for (j=0; j<cat; j++)
	    left_total[j] = 0.0;
	left_sum = 0.0;

	category_weight(xyw, cat, data_length, right_total);
	right_sum = w_sum;

	for (j=0; j<(data_length-1); j++) {

	    this_y = xyw[j].y;
	    this_w = xyw[j].w;
	    /*	    mexPrintf("   point %d: x = %g, y = %d, w = %g\n", j,
		    xyw[j].x, this_y, this_w	); */
	    
	    left_total[this_y] += this_w;
	    left_sum += this_w;

	    right_total[this_y] -= this_w;
	    right_sum -= this_w;

	    /* Now to calculate max(left_total) and max(right_total) */
	    left_max = -1.0;
	    right_max = left_max;
	    
	    for (k=0; k<cat; k++) {

		if (left_total[k] > left_max) {
		    left_max = left_total[k];
		    left_index = k;
		}

		if (right_total[k] > right_max) {
		    right_max = right_total[k];
		    right_index = k;
		}
	    }

	    /* Calculate individial and combined impurities */
	    Qleft  = 1.0 - left_max / left_sum;
	    Qright = 1.0 - right_max / right_sum;

	    this_Q = (Qleft * left_sum + Qright * right_sum) / w_sum;
	    
	    if (this_Q < best_Q) {
		tmp_var = i;
		tmp_val = xyw[j].x;
		best_Q = this_Q;
		tmp_left = left_index;
		tmp_right = right_index;
	    }
	}
    }

    *var = tmp_var + 1;
    *val = tmp_val;
    *left_cat = tmp_left;
    *right_cat = tmp_right;

    mxFree(xyw);
    mxFree(left_total);
    mxFree(right_total);

}


void category_weight(struct xyw *xyw, int cat, int data_len, double *weights)
{
    int j;

    for (j=0; j<cat; j++)
	weights[j] = 0.0;

    for (j=0; j<data_len; j++)
	weights[xyw[j].y] += xyw[j].w;
}


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* First argument, obj, is ignored */
     
    /* function [var, val, left_cat, right_cat] = 
     *            train_guts(obj, x, y, w, dimensions, cat);
     */

    double *x, *y, *w, d_dim, d_cat;
    int *y_int;
    int dimensions, data_length, cat;

    int var;
    double val;
    int left_cat;
    int right_cat;

    double *out1, *out2, *out3, *out4;

    int i;

    x = mxGetPr(prhs[1]);
    y = mxGetPr(prhs[2]);
    w = mxGetPr(prhs[3]);

    d_dim = mxGetScalar(prhs[4]);
    d_cat = mxGetScalar(prhs[5]);

    dimensions = (int)d_dim;
    cat = (int)d_cat;

    data_length = mxGetM(prhs[1]);

    y_int = mxCalloc(data_length, sizeof(int));
    
    for (i=0; i<data_length; i++) {
	y_int[i] = (int)y[i];
	/*	mexPrintf("y[%d] = %d\n", i, y_int[i]); */
    }

    optimal_split(x, y_int, w, dimensions, data_length, cat, &var, &val,
		  &left_cat, &right_cat);
		  

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);

    out1 = mxGetPr(plhs[0]);
    out2 = mxGetPr(plhs[1]);
    out3 = mxGetPr(plhs[2]);
    out4 = mxGetPr(plhs[3]);

    *out1 = (double)var;
    *out2 = (double)val;
    *out3 = (double)left_cat;
    *out4 = (double)right_cat;

    mxFree(y_int);
}


    


