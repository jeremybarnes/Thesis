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

#include "matlab_common.c"

void do_classify(const mxArray_t *obj, const mxArray_t *x, double *y,
		 int data_len, int cat)
{

    double *votes, *b, *their_b, b_sum, b_sum_recip, this_b;
    double max_value, this_vote, *this_y;
    mxArray_t *f_b, *f_iterations, *classifiers, *f_this_y;	
    mxArray_t *this_classifier;
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

    call_matlab_1_1(&f_b, "classifier_weights", obj);
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

    /* CLASSIFIERS is a cell array, each element of which is a CLASSIFIER
       object corresponding to an instance of a weak learner. */

    classifiers = mxGetField(obj, 0, "classifiers");
    if (classifiers == NULL) {
	mexErrMsgTxt("classify: Error reading CLASSIFIERS field");
	return;
    }


    /* Now go through each classifer, getting it to classify each
       datapoint, and add its votes up for each. */

    for (i=0; i<iterations; i++) {

	this_b = b[i];

	this_classifier = mxGetCell(classifiers, i);
	if (this_classifier == NULL) {
	    mexErrMsgTxt("classify: Error reading THIS_CLASSIFIER");
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
void mexFunction(int nlhs, mxArray_t *plhs[],
		 int nrhs, const mxArray_t *prhs[])
{
    double *y;
    mxArray_t *f_dimensions, *f_numcategories, *obj, *classifier;
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
    do_classify(obj, prhs[1], y, data_len, categories);
}
