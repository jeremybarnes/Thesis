/* matlab_common.c
  Jeremy Barnes, 27/9/1999
  $Id$

  This file is designed to be #included into others; it defines some useful
  functions.

  I should probably put it in a central location and link rather than include
  it.  But, you know...
*/

#ifndef __matlab_common_c
#define __matlab_common_c

#define mxArray_t mxArray
#define mxClassID_t mxClassID


void call_matlab_1_1(mxArray_t **lhs0, char *command, const mxArray_t *rhs0)
{
    /* This function calls MATLAB, executing the given command on the
       given argument and returning the result. */
    
    mxArray_t *lparams[1], *rparams[1];

    /* Get MATLAB to perform the function we ask it to */
    (const mxArray_t *)rparams[0] = rhs0;
    mexCallMATLAB(1, lparams, 1, rparams, command);
    *lhs0 = lparams[0];
}	


void call_matlab_1_2(mxArray_t **lhs0, char *command,
		     const mxArray_t *rhs0, const mxArray_t *rhs1)
{
    /* This function calls MATLAB, executing the given command on the
       given argument and returning the result. */
    
    mxArray_t *lparams[1], *rparams[2];
    
    /* Get MATLAB to ask our classifier to classify the data */
    
    (const mxArray_t *)rparams[0] = rhs0;
    (const mxArray_t *)rparams[1] = rhs1;
    
    mexCallMATLAB(1, lparams, 2, rparams, command);
    
    *lhs0 = lparams[0];
}	

int matlab_isa(const mxArray_t *obj, char *class)
{
    /* This function calls the ISA method of MATLAB to determine if the
       object is a descendent of the specified class. */

    mxArray_t *str = mxCreateString(class);
    mxArray_t *res;
    int answer;

    call_matlab_1_2(&res, "isa", obj, str);
    answer =  (int)mxGetScalar(res);

    mxDestroyArray(str);
    mxDestroyArray(res);

    return answer;
}


void print_variable(const mxArray_t *obj)
{
    /* Print out information about the MATLAB variable that obj
       points to */

    const char *class_name = "none";
    const char *variable_name = "none";
    int ndims = 1, i;
    const int *dims;
    mxClassID_t class_id;

    class_name = mxGetClassName(obj);
    if (class_name == NULL) class_name = "null";
    

    variable_name = mxGetName(obj);
    if (variable_name == NULL) variable_name = "null";

    ndims = mxGetNumberOfDimensions(obj);
    dims = mxGetDimensions(obj);
    class_id = mxGetClassID(obj);
    
    mexPrintf("Array: name = \"%s\", class = \"%s\", class_id = %d"
	      ", ndims = %d, size = [", variable_name, class_name, 
	      class_id, ndims);

    for (i=0; i<ndims-1; i++)
	mexPrintf("%dx", dims[i]);

    mexPrintf("%d]\n", dims[ndims-1]);
    
}


#endif

