/* @boost/classify.c
 * Jeremy Barnes, 18/5/1999
 * $Id$
 *
 * CLASSIFY classify a dataset
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
 * This is a rather complicated function.
 *
 * The data is classified by each of the weak learners.  For each sample,
 * a vote is then taken.  The "vote" is weighted by the b value for the
 * classifier.
 *
 * This may take a long time.
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>


void do_classify(const mxArray *obj, const mxArray *x, double *y,
		 int data_len, int cat)
{

    double *votes, *b, *their_b, b_sum, b_sum_recip, this_b;
    double max_value, this_vote, *this_y;
    mxArray *f_b, *f_iterations;	
    mxArray *this_classifier, *lparams[1], *rparams[2];
    int i, j, iterations, max_cat;

    /* We need a votes matrix.  There is an entry for each category
       for each datapoint.  The entries for each datapoint are clumped
       together.  For example, if there are 2 categories and 3
       datapoints, then the votes entries are:

       votes[0] = datapoint 0, category 0
       votes[1] = datapoint 0, category 1
       votes[2] = datapoint 1, category 0
       votes[3] = datapoint 1, category 1
       votes[4] = datapoint 2, category 0
       votes[5] = datapoint 2, category 1

       This allows good locailty of reference, which should speed things
       up for large datasets (makes better use of cache). */

    votes = mxCalloc(data_len * cat, sizeof(double));
    if (votes == NULL) {
	mexErrMsgTxt("classify: out of memory to allocate VOTES!");
	return;
    }
    
    for (i=0; i<(data_len * cat); i++)
	votes[i] = 0.0;
    
    /* Get the b vector from obj, and normalise it.  This is important,
       as they are all negative, and the sign needs to be changed. */

    f_b = mxGetField(obj, 0, "b");
    if (f_b == NULL) {
	mexErrMsgTxt("classify: Error reading B field");
	return;
    }

    their_b = mxGetPr(f_b);

    f_iterations = mxGetField(obj, 0, "iterations");
    if (f_iterations == NULL) {
	mexErrMsgTxt("classify: Error reading ITERATIONS field");
	return;
    }

    iterations = (int)mxGetScalar(f_iterations);

    if (iterations == 0) {
	/* We have not trained, so how the hell are we supposed to	
	   classify? */
	
	/* Don't cause an error, as this seems to break the rest of
	   our code. */
	/*
	mexErrMsgTxt("classify: Can't classify with zero iterations");
	*/

	for (i=0; i<data_len; i++)
	    y[i] = 0;

	return;
    }

    b = mxCalloc(iterations, sizeof(double));
    if (b == NULL) {
	mexErrMsgTxt("classify: out of memory to allocate B!");
	return;
    }

    b_sum = 0.0;
    for (i=0; i<iterations; i++)
	b_sum += their_b[i];

    b_sum_recip = 1.0 / b_sum;

    for (i=0; i<iterations; i++)
	b[i] = their_b[i] * b_sum_recip;
    

    /* Now go through each classifer, getting it to classify each
       datapoint, and add its votes up for each. */

    for (i=0; i<iterations; i++) {

	this_b = b[i];

	this_classifier = mxGetField(obj, i, "classifiers");
	if (this_classifier == NULL) {
	    mexErrMsgTxt("classify: Error reading CLASSIFIER field");
	    return;
	}


	/* Get MATLAB to ask our classifier to classify the data */

	(const mxArray *)rparams[0] = this_classifier;
	(const mxArray *)rparams[1] = x;

	mexCallMATLAB(1, lparams, 2, rparams, "classify");

	this_y = mxGetPr(lparams[0]);
	
	/* Add the votes on */
	for (j=0; j<data_len; j++)
	    votes[j*cat + (int)this_y[j]] += this_b;

	/* Free the array that the classify routine created */
	mxDestroyArray(lparams[0]);

    }

    /* Now, for each of the samples, find the one with the most votes
       and return this in y. */
    for (i=0; i<data_len; i++) {

	max_value = votes[i*cat];
	max_cat = 0;

	for (j=1; j<cat; j++) {
	    this_vote = votes[i*cat+j];
	    if (this_vote > max_value) {
		max_value = this_vote;
		max_cat = j;
	    }
	}

	y[i] = (double)max_cat;
    }

    mxFree(b);
    mxFree(votes);

}


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *y;
    mxArray *f_dimensions, *f_categories, *rparams[1], *lparams[1];
    int dimensions, data_len, categories;

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

    /* Make sure its a BOOST object */
    if (!mxIsClass(prhs[0], "boost")) {
	mexErrMsgTxt("classify: First input must be of type BOOST");
	return;
    }
    
    /* Get our number of dimensions */
    f_dimensions = mxGetField(prhs[0], 0, "dimensions");
    if (f_dimensions == NULL) {
	mexErrMsgTxt("classify: Error reading DIMENSIONS field");
	return;
    }
    
    dimensions = (int)mxGetScalar(f_dimensions);

    /* Ask MATLAB to tell us how many categories are in our dataset */
    f_categories = mxGetField(prhs[0], 0, "categories");
    if (f_categories == NULL) {
	mexErrMsgTxt("classify: Error reading CATEGORIES field");
	return;
    }

    rparams[0] = f_categories;

    mexCallMATLAB(1, lparams, 1, rparams, "numcategories");

    categories = (int)(*mxGetPr(lparams[0]));
    mxDestroyArray(lparams[0]);

    /* Get our X variable.  Make sure its a matrix, and get its number of
       rows and columns. */
    if (!mxIsClass(prhs[1], "double")) {
	mexErrMsgTxt("classify: x must be a double array");
	return;
    }

    data_len = mxGetM(prhs[1]);

    /* Check that the number of dimensions matches */
    if (dimensions != mxGetN(prhs[1])) {
	mexErrMsgTxt("classify: dimensions of x and obj don't match");
	return;
    }

    /* Create storage for our output */
    plhs[0] = mxCreateDoubleMatrix(data_len, 1, mxREAL);
    if (plhs[0] == NULL) {
	mexErrMsgTxt("classify: out of memory allocating Y!");
	return;
    }

    y = mxGetPr(plhs[0]);

    /* Call our computational routine */
    do_classify(prhs[0], prhs[1], y, data_len, categories);

}



