/* @cart/classify.c
 * Jeremy Barnes, 17/5/1999
 * $Id$
 *
 * CLASSIFY classify a set of data
 *
 * SYNTAX:
 *
 * y = classify(obj, x)
 *
 * Classifies the data in X using the classifier OBJ.  Returns the class
 * labels in Y.
 *
 * RETURNS:
 *
 * The class labels in Y.
 *
 * The tree is traversed recursively, at each point splitting the input
 * data on the split variable, until a terminal node is reached.  The
 * results are then passed upwards through the tree as the recursive
 * procedures return, being reassembled as they go.
 *
 * This allows for efficient classification of larger datasets.  It may be
 * less than optimal for smaller datasets.
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>


void split_data(double *x, int data_len, int splitvar, double splitval,
		int dim,
		double **p_left_x, int **p_left_index, int *p_left_len,
		double **p_right_x, int **p_right_index, int *p_right_len);

void merge_data(int *y, int dim, 
		int *left_y, int *left_index, int left_len,
		int *right_y, int *right_index,int right_len);

void recursive_classify(mxArray *tree, double *x, int data_len, int *y,
			int dim);



void recursive_classify(mxArray *tree, double *x, int data_len, int *y,
			int dim)
{
    int isterminal, category, i, j;
    mxArray *f_isterminal, *f_category;

    /*
    mexPrintf("recursive_classify (%d data points, %d dimensions)\n",
	      data_len, dim);
    mexPrintf("input:\n");
    for (i=0; i<data_len; i++) {
	mexPrintf("    x: ");
	for (j=0; j<dim; j++)
	    mexPrintf("%12.4g  ", x[data_len*j + i]);
	mexPrintf("    y: %d\n", y[i]);
    }
    */

    /* Check for the trivial case */
    if (data_len == 0)
	return;

    /* Check for a terminal node */
    f_isterminal = mxGetField(tree, 0, "isterminal");
    if (f_isterminal == NULL)
	mexErrMsgTxt("classify: Error reading ISTERMINAL field");

    isterminal = (int)mxGetScalar(f_isterminal);

    if (isterminal) {
	f_category = mxGetField(tree, 0, "category");
	if (f_category == NULL)
	    mexErrMsgTxt("classify: Error reading CATEGORY field");

	category = (int)mxGetScalar(f_category);

	/*mexPrintf("  TERMINAL: category = %d\n", category); */

	for (i=0; i<data_len; i++)
	    y[i] = category; /* use setmem for speed? */
    }
    else { /* not a terminal node */

	/* If we reach this point, then we have a subtree to contend with.
	 * We need to split our data on the specified variable (just as
         * in the train method) and recursively call this procedure for
	 * each of the left and right trees.  However, we must be very
	 * careful to keep track of the order of our data samples, so that
	 * we can eventually reconstruct them in the same order they were in.
	 */

	int splitvar, *left_index, *right_index, left_len, right_len;
	int *left_y, *right_y;
	double splitval, *left_x, *right_x;
	mxArray *f_splitvar, *f_splitval, *left, *right;

	/* Get our field values out */
	f_splitvar = mxGetField(tree, 0, "splitvar");
	if (f_splitvar == NULL)
	    mexErrMsgTxt("classify: Error reading SPLITVAR field");
	
	splitvar = (int)mxGetScalar(f_splitvar);

	f_splitval = mxGetField(tree, 0, "splitval");
	if (f_splitval == NULL)
	    mexErrMsgTxt("classify: Error reading SPLITVAL field");

	splitval = mxGetScalar(f_splitval);

	left = mxGetField(tree, 0, "left");
	if (left == NULL)
	    mexErrMsgTxt("classify: Error reading LEFT field");

	right = mxGetField(tree, 0, "right");
	if (right == NULL)
	    mexErrMsgTxt("classify: Error reading RIGHT field");

	/*mexPrintf("  NONTERMINAL: splitvar = %d, splitval = %g\n",
	  splitvar, splitval);*/

	/* Split the data up */
	split_data(x, data_len, splitvar, splitval, dim,
		   &left_x, &left_index, &left_len,
		   &right_x, &right_index, &right_len);

	/* Classify both halves */
	left_y = mxCalloc(left_len, sizeof(int));
	right_y = mxCalloc(right_len, sizeof(int));

	recursive_classify(left, left_x, left_len, left_y, dim);
	recursive_classify(right, right_x, right_len, right_y, dim);

	/* Put the data back together */
	merge_data(y, dim, left_y, left_index, left_len,
		   right_y, right_index, right_len);

	/* Deallocate our storage */
	mxFree(left_x);
	mxFree(left_y);
	mxFree(left_index);
	mxFree(right_x);
	mxFree(right_y);
	mxFree(right_index);
    }

    /*
    mexPrintf("output:\n");
    for (i=0; i<data_len; i++) {
	mexPrintf("    x: ");
	for (j=0; j<dim; j++)
	    mexPrintf("%12.4g  ", x[data_len*j + i]);
	mexPrintf("    y: %d\n", y[i]);
    }
    mexPrintf("\n\n");
    */

}

void split_data(double *x, int data_len, int splitvar, double splitval,
		int dim,
		double **p_left_x, int **p_left_index, int *p_left_len,
		double **p_right_x, int **p_right_index, int *p_right_len)
{
    /* SPLIT_DATA separate a dataset by splitting on value of one
     * variable.
     *
     * This function takes a dataset {X,Y,W} and splits it into two
     * disjoint parts.  The two parts are split on one variable of X
     * (the variable given by SPLITVAR), into "left" and "right"
     * datasets {LEFT_X, LEFT_Y} and {RIGHT_X, RIGHT_Y}.  The left
     * half satisfies X(SPLITVAR) <= SPLITVAL, with the right half
     * satisfying X(SPLITVAR) > SPLITVAL.
     *
     * Separate our data into left and right halves.  To do this,
     * create an index vector which shows which data points are to
     * the left and the right of the split point.
     */

    double *left_x, *right_x, *px, *pcx, *plx, *prx;
    int *left_index, *right_index, left_len, right_len, *pli, *pri;
    int i, j;

    /* Determine how many points are in the left and right category */
    left_len = 0;
    px = x + (splitvar - 1)*data_len;
    for (i=0; i<data_len; i++)
	if (px[i] <= splitval) left_len++;
    
    right_len = data_len - left_len;

    /* Allocate our memory */
    left_x = mxCalloc(left_len*dim, sizeof(double));
    right_x = mxCalloc(right_len*dim, sizeof(double));

    left_index = mxCalloc(left_len, sizeof(int));
    right_index = mxCalloc(right_len, sizeof(int));

    /* Do our stuff */
    px = x;				/* current x, first row */
    pcx = x + (splitvar - 1)*data_len;	/* current x, splitvar row */
    plx = left_x;			/* current left_x */
    prx = right_x;			/* current right_x */
    pli = left_index;			/* current left_index */
    pri = right_index;			/* current right_index */

    for (i=0; i<data_len; i++) {

	if (pcx[i] <= splitval) { /* left */

	    *pli++ = i;

	    for (j=0; j<dim; j++)
		plx[j*left_len] = px[j*data_len];
	    
	    plx++;
	}


	else { /* right */

	    *pri++ = i;

	    for (j=0; j<dim; j++)
		prx[j*right_len] = px[j*data_len];

	    prx++;
	}

	px++;
    }
	    

    /* Copy our variables over */
    *p_left_x = left_x;
    *p_left_index = left_index;
    *p_left_len = left_len;

    *p_right_x = right_x;
    *p_right_index = right_index;
    *p_right_len = right_len;
}


void merge_data(int *y, int dim, 
		int *left_y, int *left_index, int left_len,
		int *right_y, int *right_index, int right_len)
{
    /* MERGE_DATA merge together a dataset split using SPLIT_DATA */

    int i, j, data_len, this_index, *py, *pi;

    data_len = left_len + right_len;

    py = left_y;
    pi = left_index;

    for (i=0; i<left_len; i++) {
	this_index = *pi++;
	y[this_index] = *py++;
    }


    py = right_y;
    pi = right_index;

    for (i=0; i<right_len; i++) {
	this_index = *pi++;
	y[this_index] = *py++;
    }
}



/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* First argument, obj, is ignored */
     
    /* function [var, val, left_cat, right_cat] = 
     *            train_guts(obj, x, y, w, dimensions, cat);
     */

    double *x, *y_double;
    mxArray *f_dimensions, *tree;
    int i, *y, dimensions, data_len;

    /* Check that we have 2 RHS arguments */
    if (nrhs != 2) {
	mexErrMsgTxt("classify: There must be exactly two arguments");
	return;
    }
    
    /* Check that we have zero or one LHS arguments */
    if ((nlhs < 0) || (nlhs > 1)) {
	mexErrMsgTxt("classify: Too many output arguments");
	return;
    }

    if (nlhs == 0) return;

    /* Make sure its a CART object */
    if (!mxIsClass(prhs[0], "cart")) {
	mexErrMsgTxt("classify: First input must be of type CART");
	return;
    }
    
    /* Get our number of dimensions */
    f_dimensions = mxGetField(prhs[0], 0, "dimensions");
    if (f_dimensions == NULL) {
	mexErrMsgTxt("classify: Error reading DIMENSIONS field");
	return;
    }
    
    dimensions = (int)mxGetScalar(f_dimensions);

    /* Get our tree structure */
    tree = mxGetField(prhs[0], 0, "tree");
    if (tree == NULL) {
	mexErrMsgTxt("classify: Error reading TREE field");
	return;
    }

    /* Get our X variable.  Make sure its a matrix, and get its number of
       rows and columns. */
    if (!mxIsClass(prhs[1], "double")) {
	mexErrMsgTxt("classify: x must be a double array");
	return;
    }

    x = mxGetPr(prhs[1]);
    data_len = mxGetM(prhs[1]);

    /* Check that the number of dimensions matches */
    if (dimensions != mxGetN(prhs[1])) {
	mexErrMsgTxt("classify: dimensions of x and obj don't match");
	return;
    }

    /* Create storage for our output */
    y = mxCalloc(data_len, sizeof(int));

    /* Call our computational routine */
    /*    mexErrMsgTxt("About to call recursive_classify");
	  return; */
    
    recursive_classify(tree, x, data_len, y, dimensions);

    /* Write our output */
    plhs[0] = mxCreateDoubleMatrix(data_len, 1, mxREAL);
    y_double = mxGetPr(plhs[0]);

    for (i=0; i<data_len; i++) {
	y_double[i] = (double)y[i];
    }

    /* Free up storage */
    mxFree(y);

}
