/* @boost/margins.c
 * Jeremy Barnes, 18/5/1999
 * $Id$
 *
 * MARGINS return the margins of a dataset
 */

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "matrix.h"
#include "mex.h"
#include <memory.h>

#include "matlab_common.c"


void do_margins(const mxArray *obj, const mxArray *x, double *m,
		 int data_len, int cat)
{

    double *votes, *b, *their_b, this_b;
    double max_value, second_max_value, this_vote, *this_y;
    mxArray_t *f_b, *f_iterations, *classifiers;	
    mxArray_t *this_classifier, *f_this_y;
    int i, j, iterations;

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
	mexErrMsgTxt("margins: out of memory to allocate VOTES!");
	return;
    }
    
    for (i=0; i<(data_len * cat); i++)
	votes[i] = 0.0;
    
    /* Get the b vector from obj, and normalise it.  This is important,
       as they are all negative, and the sign needs to be changed. */


    call_matlab_1_1(&f_b, "classifier_weights", obj);
    if (f_b == NULL) {
	mexErrMsgTxt("margins: Error reading B field");
	return;
    }

    their_b = mxGetPr(f_b);


    call_matlab_1_1(&f_iterations, "iterations", obj);
    if (f_iterations == NULL) {
	mexErrMsgTxt("margins: Error reading ITERATIONS field");
	return;
    }

    iterations = (int)mxGetScalar(f_iterations);

    if (iterations == 0) {
	/* We have not trained, so how the hell are we supposed to	
	   classify? */
	
	/* Don't cause an error, as this seems to break the rest of
	   our code. */
	/*
	mexErrMsgTxt("margins: Can't classify with zero iterations");
	*/

	for (i=0; i<data_len; i++)
	    m[i] = 0;

	return;
    }

    b = mxCalloc(iterations, sizeof(double));
    if (b == NULL) {
	mexErrMsgTxt("margins: out of memory to allocate B!");
	return;
    }

    /* 6/8/99 -- Removing the normalisation part so that I can get
       "margins" that are useful for testing stuff out.  Just taking
       the absolute value instead.
    */

    for (i=0; i<iterations; i++)
	b[i] = fabs(their_b[i]);
    
    /* classifiers is a cell array of classifiers */
    classifiers = mxGetField(obj, 0, "classifiers");
    /*     call_matlab_1_1(&classifiers, "wl_instance", obj); */
    if (classifiers == NULL) {
	mexErrMsgTxt("margins: Error reading CLASSIFIERS field");
	return;
    }

    /* Now go through each classifer, getting it to classify each
       datapoint, and add its votes up for each. */

    for (i=0; i<iterations; i++) {

	this_b = b[i];

	this_classifier = mxGetCell(classifiers, i);
	if (this_classifier == NULL) {
	    mexErrMsgTxt("margins: Error reading THIS_CLASSIFIER");
	    return;
	}


	/* Get MATLAB to ask our classifier to classify the data */
	call_matlab_1_2(&f_this_y, "classify", this_classifier, x);
	this_y = mxGetPr(f_this_y);

	/* Add the votes on */
	for (j=0; j<data_len; j++)
	    votes[j*cat + (int)this_y[j]] += this_b;

	/* Free the array that the classify routine created */
	mxDestroyArray(f_this_y);

    }

    /* Now, for each of the samples, find the one with the most votes
       and return this in y. */
    if (cat == 1) {
	for (i=0; i<data_len; i++)
	    m[i] = 1.0;
    }
    else {
	for (i=0; i<data_len; i++) {

	    if (votes[i*cat] > votes[i*cat+1]) {
		max_value = votes[i*cat];	
		second_max_value = votes[i*cat+1];
	    } else {
		second_max_value = votes[i*cat];	
		max_value = votes[i*cat+1];
	    }

	    for (j=2; j<cat; j++) {
		this_vote = votes[i*cat+j];
		if (this_vote > max_value) {
		    second_max_value = max_value;
		    max_value = this_vote;
		}
		else if (this_vote > second_max_value) {
		    second_max_value = this_vote;
		}	
	    }

	    m[i] = max_value - second_max_value;
	}

    }


    mxFree(b);
    mxFree(votes);

}


/* Gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *m;
    mxArray_t *f_dimensions, *f_numcategories, *obj, *classifier;
    int dimensions, data_len, categories;

    /* Check that we have 2 RHS arguments */
    if (nrhs != 2) {
	mexErrMsgTxt("margins: There must be exactly two arguments");
	return;
    }
    
    /* Check that we have zero or one LHS arguments */
    if ((nlhs < 0) || (nlhs > 1)) {
	mexErrMsgTxt("margins: Too many output arguments");
	return;
    }

    if (nlhs == 0) return;

    (const mxArray_t *)obj = prhs[0];

    /* Turn it into a BOOST object */
    call_matlab_1_1(&obj, "as_boost", prhs[0]);

    /* NOTE: This is a hack, but seems necessary as MATLAB won't seem to
       recognise that obj has an inherited DIMENSIONS method from the
       CLASSIFIER ancestor. */
    call_matlab_1_1(&classifier, "as_classifier", obj);
    
    /* Get our number of dimensions */
    call_matlab_1_1(&f_dimensions, "dimensions", classifier);
    dimensions = (int)mxGetScalar(f_dimensions);
    mxDestroyArray(f_dimensions);

    /* Ask MATLAB to tell us how many categories are in our dataset */
    call_matlab_1_1(&f_numcategories, "numcategories", classifier);
    categories = (int)mxGetScalar(f_numcategories);
    mxDestroyArray(f_numcategories);
    mxDestroyArray(classifier);

    /* Get our X variable.  Make sure its a matrix, and get its number of
       rows and columns. */
    if (!mxIsClass(prhs[1], "double")) {
	mexErrMsgTxt("margins: x must be a double array");
	return;
    }

    data_len = mxGetM(prhs[1]);

    /* Check that the number of dimensions matches */
    if (dimensions != mxGetN(prhs[1])) {
	mexErrMsgTxt("margins: dimensions of x and obj don't match");
	return;
    }

    /* Create storage for our output */
    plhs[0] = mxCreateDoubleMatrix(data_len, 1, mxREAL);
    if (plhs[0] == NULL) {
	mexErrMsgTxt("margins: out of memory allocating M!");
	return;
    }

    m = mxGetPr(plhs[0]);

    /* Call our computational routine */
    do_margins(obj, prhs[1], m, data_len, categories);

}
