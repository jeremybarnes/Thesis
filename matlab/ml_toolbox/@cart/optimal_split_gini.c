/* @cart/optimal_split_gini.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * calculates the optimal split location for CART, using the "gini"
 * loss function.
 *
 *
 * MATLAB syntax:
 *
 * function [var, val, left_cat, right_cat] = 
 *            train_guts(obj, x, y, w, dimensions, cat);
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
/* Compare two struct xyw's, and return -1 or +1 depending upon which
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
		   int *no_optimal)
{
    int i, j, k, this_y, *yp, tmp_var, tmp_nooptimal;
    double *xp, this_w, *wp;
    double w_sum, left_sum, *left_total, *left_dens,
	   right_sum, *right_total, *right_dens;
    double tmp_val, this_Q, best_Q, left_Q, right_Q;

    struct xyw *xyw;


    /* Allocate memory */
    xyw = mxCalloc(data_length, sizeof(struct xyw));
    left_total = mxCalloc(cat, sizeof(double));
    right_total = mxCalloc(cat, sizeof(double));
    left_dens = mxCalloc(cat, sizeof(double));
    right_dens = mxCalloc(cat, sizeof(double));


    /* Calculate the Q of the whole dataset, to be able to determine
     * if our split gets better or not (no_optimal)
     */
    category_weight(xyw, cat, data_length, right_total);

    /* calculate sum of w values */
    w_sum = 0.0;
    for (j=0; j<data_length; j++) {
	w_sum += w[j];
    }

    best_Q = 0.0;

    for (i=0; i<cat; i++) {
	best_Q += (right_total[i] * right_total[i]);
    }

    best_Q = - best_Q / w_sum;
	

    /* There is no optimal if we don't find one */
    tmp_nooptimal = 1;

    for (i=0; i<dimensions; i++) {

	xp = x + (i*data_length);
	yp = y;
	wp = w;
	
	/* Copy data into our array */
	for (j=0; j<data_length; j++) {
	    xyw[j].x = *xp++;
	    xyw[j].y = *yp++;
	    xyw[j].w = *wp++;
	}
	
	/* sort ALL of the data on the x value */
	qsort((void *)xyw, data_length, sizeof(struct xyw), compare);

	/* Initialise variables */
	for (j=0; j<cat; j++)
	    left_total[j] = 0.0;
	left_sum = 0.0;

	category_weight(xyw, cat, data_length, right_total);
	right_sum = w_sum;


	for (j=0; j<(data_length-1); j++) {

	    this_y = xyw[j].y;
	    this_w = xyw[j].w;
	    
	    left_total[this_y] += this_w;
	    left_sum += this_w;

	    right_total[this_y] -= this_w;
	    right_sum -= this_w;

	    /* Convert our totals into densities (very expensive...) */
	    for (k=0; k<cat; k++) {
		left_dens[k] = left_total[k];
		right_dens[k] = right_total[k];
	    }

	    /* Calculate our left and right Gini functions */
	    left_Q = 0.0;
	    right_Q = 0.0;
	    for (k=0; k<cat; k++) {
		left_Q -= left_dens[k] * left_dens[k];
		right_Q -= right_dens[k] * right_dens[k];
	    }

	    /* Calculate our new impurity */
	    this_Q = (left_Q / left_sum + right_Q / right_sum);
	    
	    if (this_Q < best_Q) {
		tmp_var = i;
		tmp_val = (xyw[j].x + xyw[j+1].x) * 0.5;
		tmp_nooptimal = 0;
		best_Q = this_Q;
	    }
	}
    }

    *var = tmp_var + 1;
    *val = tmp_val;
    *no_optimal = tmp_nooptimal;

    mxFree(xyw);
    mxFree(left_total);
    mxFree(right_total);
    mxFree(left_dens);
    mxFree(right_dens);

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

    double *x, *y, *w;
    int *y_int;
    int dimensions, data_length, cat;

    int var=1, no_optimal=1;
    double val=0.5;

    double *out1, *out2, *out3;

    int i;

    x = mxGetPr(prhs[1]);
    y = mxGetPr(prhs[2]);
    w = mxGetPr(prhs[3]);

    dimensions = mxGetN(prhs[1]);
    cat = (int)mxGetScalar(prhs[4]);

    data_length = mxGetM(prhs[1]);

    y_int = mxCalloc(data_length, sizeof(int));
    
    for (i=0; i<data_length; i++) {
	y_int[i] = (int)y[i];
    }

    optimal_split(x, y_int, w, dimensions, data_length, cat, &var, &val,
		  &no_optimal);

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);

    out1 = mxGetPr(plhs[0]);
    out2 = mxGetPr(plhs[1]);
    out3 = mxGetPr(plhs[2]);

    *out1 = (double)var;
    *out2 = (double)val;
    *out3 = (double)no_optimal;

    mxFree(y_int);
}
/* @cart/optimal_split_gini.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * calculates the optimal split location for CART, using the "gini"
 * loss function.
 *
 *
 * MATLAB syntax:
 *
 * function [var, val, left_cat, right_cat] = 
 *            train_guts(obj, x, y, w, dimensions, cat);
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
/* Compare two struct xyw's, and return -1 or +1 depending upon which
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
		   int *no_optimal)
{
    int i, j, k, this_y, *yp, tmp_var, tmp_nooptimal;
    double *xp, this_w, *wp;
    double w_sum, left_sum, *left_total, right_sum, *right_total;
    double tmp_val, this_Q, best_Q, left_Q, right_Q;

    struct xyw *xyw;


    /* Allocate memory */
    xyw = mxCalloc(data_length, sizeof(struct xyw));
    left_total = mxCalloc(cat, sizeof(double));
    right_total = mxCalloc(cat, sizeof(double));

    /* Calculate the Q of the whole dataset, to be able to determine
     * if our split gets better or not (no_optimal)
     */
    category_weight(xyw, cat, data_length, right_total);

    /* calculate sum of w values */
    w_sum = 0.0;
    for (j=0; j<data_length; j++) {
	w_sum += w[j];
    }

    best_Q = 0.0;

    for (i=0; i<cat; i++) {
	best_Q += (right_total[i] * right_total[i]);
    }

    best_Q = - best_Q / w_sum;
	

    /* There is no optimal if we don't find one */
    tmp_nooptimal = 1;

    for (i=0; i<dimensions; i++) {

	xp = x + (i*data_length);
	yp = y;
	wp = w;
	
	/* Copy data into our array */
	for (j=0; j<data_length; j++) {
	    xyw[j].x = *xp++;
	    xyw[j].y = *yp++;
	    xyw[j].w = *wp++;
	}
	
	/* sort ALL of the data on the x value */
	qsort((void *)xyw, data_length, sizeof(struct xyw), compare);

	/* Initialise variables */
	for (j=0; j<cat; j++)
	    left_total[j] = 0.0;
	left_sum = 0.0;

	category_weight(xyw, cat, data_length, right_total);
	right_sum = w_sum;


	for (j=0; j<(data_length-1); j++) {

	    this_y = xyw[j].y;
	    this_w = xyw[j].w;
	    
	    left_total[this_y] += this_w;
	    left_sum += this_w;

	    right_total[this_y] -= this_w;
	    right_sum -= this_w;

	    /* Calculate our left and right "Gini" (well, not really
	       after all this optimisation...) functions */
	    left_Q = 0.0;
	    right_Q = 0.0;
	    for (k=0; k<cat; k++) {
		left_Q -= left_total[k] * left_total[k];
		right_Q -= right_total[k] * right_total[k];
	    }

	    /* Calculate our new impurity */
	    this_Q = (left_Q / left_sum + right_Q / right_sum);
	    
	    if (this_Q < best_Q) {
		tmp_var = i;
		tmp_val = (xyw[j].x + xyw[j+1].x) * 0.5;
		tmp_nooptimal = 0;
		best_Q = this_Q;
	    }
	}
    }

    *var = tmp_var + 1;
    *val = tmp_val;
    *no_optimal = tmp_nooptimal;

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

    double *x, *y, *w;
    int *y_int;
    int dimensions, data_length, cat;

    int var=1, no_optimal=1;
    double val=0.5;

    double *out1, *out2, *out3;

    int i;

    x = mxGetPr(prhs[1]);
    y = mxGetPr(prhs[2]);
    w = mxGetPr(prhs[3]);

    dimensions = mxGetN(prhs[1]);
    cat = (int)mxGetScalar(prhs[4]);

    data_length = mxGetM(prhs[1]);

    y_int = mxCalloc(data_length, sizeof(int));
    
    for (i=0; i<data_length; i++) {
	y_int[i] = (int)y[i];
    }

    optimal_split(x, y_int, w, dimensions, data_length, cat, &var, &val,
		  &no_optimal);

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);

    out1 = mxGetPr(plhs[0]);
    out2 = mxGetPr(plhs[1]);
    out3 = mxGetPr(plhs[2]);

    *out1 = (double)var;
    *out2 = (double)val;
    *out3 = (double)no_optimal;

    mxFree(y_int);
}
/* @cart/optimal_split_gini.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * calculates the optimal split location for CART, using the "gini"
 * loss function.
 *
 *
 * MATLAB syntax:
 *
 * function [var, val, left_cat, right_cat] = 
 *            train_guts(obj, x, y, w, dimensions, cat);
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
/* Compare two struct xyw's, and return -1 or +1 depending upon which
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
		   int *no_optimal)
{
    int i, j, k, this_y, *yp, tmp_var, tmp_nooptimal;
    double *xp, this_w, *wp;
    double w_sum, left_sum, *left_total, right_sum, *right_total;
    double *left_total_squared, *right_total_squared;
    double left_sum_squares, right_sum_squares;
    double tmp_val, this_Q, best_Q, left_Q, right_Q;

    struct xyw *xyw;


    /* Allocate memory */
    xyw = mxCalloc(data_length, sizeof(struct xyw));
    left_total = mxCalloc(cat, sizeof(double));
    right_total = mxCalloc(cat, sizeof(double));
    left_total_squared = mxCalloc(cat, sizeof(double));
    right_total_squared = mxCalloc(cat, sizeof(double));

    /* Calculate the Q of the whole dataset, to be able to determine
     * if our split gets better or not (no_optimal)
     */
    category_weight(xyw, cat, data_length, right_total);

    /* calculate sum of w values */
    w_sum = 0.0;
    for (j=0; j<data_length; j++) {
	w_sum += w[j];
    }

    best_Q = 0.0;

    for (i=0; i<cat; i++) {
	best_Q += (right_total[i] * right_total[i]);
    }

    best_Q = - best_Q / w_sum;
	

    /* There is no optimal if we don't find one */
    tmp_nooptimal = 1;

    for (i=0; i<dimensions; i++) {

	xp = x + (i*data_length);
	yp = y;
	wp = w;
	
	/* Copy data into our array */
	for (j=0; j<data_length; j++) {
	    xyw[j].x = *xp++;
	    xyw[j].y = *yp++;
	    xyw[j].w = *wp++;
	}
	
	/* sort ALL of the data on the x value */
	qsort((void *)xyw, data_length, sizeof(struct xyw), compare);

	/* Initialise variables */
	for (j=0; j<cat; j++) {
	    left_total[j] = 0.0;
	    right_total_squared[j] = 0.0;
	}
	left_sum = 0.0;
	left_sum_squares = 0.0;

	category_weight(xyw, cat, data_length, right_total);
	right_sum_squares = 0.0;
	for (j=0; j<cat; j++) {
	    right_total_squared[j] = right_total[j] * right_total[j];
	    right_sum_squares += right_total[j] * right_total[j];
	}
	right_sum = w_sum;


	for (j=0; j<(data_length-1); j++) {

	    this_y = xyw[j].y;
	    this_w = xyw[j].w;
	    
	    left_sum_squares += 2*left_total[this_y]*this_w + this_w*this_w;
	    left_total[this_y] += this_w;
	    left_sum += this_w;

	    right_total[this_y] -= this_w;
	    right_sum_squares -= 2*right_total[this_y]*this_w + this_w*this_w;
	    right_sum -= this_w;

	    /* Calculate our left and right "Gini" (well, not really
	       after all this optimisation...) functions */
	    left_Q = 0.0;
	    right_Q = 0.0;
	    for (k=0; k<cat; k++) {
		left_Q -= left_total[k] * left_total[k];
		right_Q -= right_total[k] * right_total[k];
	    }

	    mexPrintf("left_sum_squares = %g, left_Q = %g, " \
		      "right_sum_squares = %g, right_Q = %g\n",
		      left_sum_squares, left_Q, right_sum_squares, right_Q);

	    /* Calculate our new impurity */
	    this_Q = (left_Q / left_sum + right_Q / right_sum);
	    
	    if (this_Q < best_Q) {
		tmp_var = i;
		tmp_val = (xyw[j].x + xyw[j+1].x) * 0.5;
		tmp_nooptimal = 0;
		best_Q = this_Q;
	    }
	}
    }

    *var = tmp_var + 1;
    *val = tmp_val;
    *no_optimal = tmp_nooptimal;

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

    double *x, *y, *w;
    int *y_int;
    int dimensions, data_length, cat;

    int var=1, no_optimal=1;
    double val=0.5;

    double *out1, *out2, *out3;

    int i;

    x = mxGetPr(prhs[1]);
    y = mxGetPr(prhs[2]);
    w = mxGetPr(prhs[3]);

    dimensions = mxGetN(prhs[1]);
    cat = (int)mxGetScalar(prhs[4]);

    data_length = mxGetM(prhs[1]);

    y_int = mxCalloc(data_length, sizeof(int));
    
    for (i=0; i<data_length; i++) {
	y_int[i] = (int)y[i];
    }

    optimal_split(x, y_int, w, dimensions, data_length, cat, &var, &val,
		  &no_optimal);

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);

    out1 = mxGetPr(plhs[0]);
    out2 = mxGetPr(plhs[1]);
    out3 = mxGetPr(plhs[2]);

    *out1 = (double)var;
    *out2 = (double)val;
    *out3 = (double)no_optimal;

    mxFree(y_int);
}
/* @cart/optimal_split_gini.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * A MEX-file (designed for insertion into MATLAB) that efficiently
 * calculates the optimal split location for CART, using the "gini"
 * loss function.
 *
 *
 * MATLAB syntax:
 *
 * function [var, val, left_cat, right_cat] = 
 *            train_guts(obj, x, y, w, dimensions, cat);
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
/* Compare two struct xyw's, and return -1 or +1 depending upon which
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
		   int *no_optimal)
{
    int i, j, k, this_y, *yp, tmp_var, tmp_nooptimal;
    double *xp, this_w, this_w_squared, *wp;
    double w_sum, left_sum, *left_total, right_sum, *right_total;
    double left_sum_squares, right_sum_squares;
    double tmp_val, this_Q, best_Q;

    struct xyw *xyw;


    /* Allocate memory */
    xyw = mxCalloc(data_length, sizeof(struct xyw));
    left_total = mxCalloc(cat, sizeof(double));
    right_total = mxCalloc(cat, sizeof(double));

    /* Calculate the Q of the whole dataset, to be able to determine
     * if our split gets better or not (no_optimal)
     */
    category_weight(xyw, cat, data_length, right_total);

    /* calculate sum of w values */
    w_sum = 0.0;
    for (j=0; j<data_length; j++) {
	w_sum += w[j];
    }

    best_Q = 0.0;

    for (i=0; i<cat; i++) {
	best_Q += (right_total[i] * right_total[i]);
    }

    best_Q = best_Q / w_sum;
	

    /* There is no optimal if we don't find one */
    tmp_nooptimal = 1;

    for (i=0; i<dimensions; i++) {

	xp = x + (i*data_length);
	yp = y;
	wp = w;
	
	/* Copy data into our array */
	for (j=0; j<data_length; j++) {
	    xyw[j].x = *xp++;
	    xyw[j].y = *yp++;
	    xyw[j].w = *wp++;
	}
	
	/* sort ALL of the data on the x value */
	qsort((void *)xyw, data_length, sizeof(struct xyw), compare);

	/* Initialise variables */
	for (j=0; j<cat; j++) {
	    left_total[j] = 0.0;
	}
	left_sum = 0.0;
	left_sum_squares = 0.0;

	category_weight(xyw, cat, data_length, right_total);
	right_sum_squares = 0.0;
	for (j=0; j<cat; j++) {
	    right_sum_squares += right_total[j] * right_total[j];
	}
	right_sum = w_sum;


	for (j=0; j<(data_length-1); j++) {

	    this_y = xyw[j].y;
	    this_w = xyw[j].w;
	    this_w_squared = this_w*this_w;
	    
	    left_sum_squares += 2*left_total[this_y]*this_w + this_w_squared;
	    left_total[this_y] += this_w;
	    left_sum += this_w;

	    right_total[this_y] -= this_w;
	    right_sum_squares -= 2*right_total[this_y]*this_w + this_w_squared;
	    right_sum -= this_w;

	    /* Every 20 iterations, recalculate to avoid errors from
	       propegating too far. */
	    if (i % 200 == 199) {
		left_sum_squares = 0.0;
		right_sum_squares = 0.0;
		for (k=0; k<cat; k++) {
		    left_sum_squares += left_total[k] * left_total[k];
		    right_sum_squares += right_total[k] * right_total[k];
		}
	    }

	    /* Calculate our new "impurity" */
	    this_Q = (left_sum_squares / left_sum +
		      right_sum_squares / right_sum);
	    
	    if (this_Q > best_Q) {
		tmp_var = i;
		tmp_val = (xyw[j].x + xyw[j+1].x) * 0.5;
		tmp_nooptimal = 0;
		best_Q = this_Q;
	    }
	}
    }

    *var = tmp_var + 1;
    *val = tmp_val;
    *no_optimal = tmp_nooptimal;

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

    double *x, *y, *w;
    int *y_int;
    int dimensions, data_length, cat;

    int var=1, no_optimal=1;
    double val=0.5;

    double *out1, *out2, *out3;

    int i;

    x = mxGetPr(prhs[1]);
    y = mxGetPr(prhs[2]);
    w = mxGetPr(prhs[3]);

    dimensions = mxGetN(prhs[1]);
    cat = (int)mxGetScalar(prhs[4]);

    data_length = mxGetM(prhs[1]);

    y_int = mxCalloc(data_length, sizeof(int));
    
    for (i=0; i<data_length; i++) {
	y_int[i] = (int)y[i];
    }

    optimal_split(x, y_int, w, dimensions, data_length, cat, &var, &val,
		  &no_optimal);

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);

    out1 = mxGetPr(plhs[0]);
    out2 = mxGetPr(plhs[1]);
    out3 = mxGetPr(plhs[2]);

    *out1 = (double)var;
    *out2 = (double)val;
    *out3 = (double)no_optimal;

    mxFree(y_int);
}
