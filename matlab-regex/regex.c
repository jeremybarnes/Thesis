/* regex.c
   Jeremy Barnes, 9/9/1999
   $Id$

   This is a MATLAB interface to the GNU regexp library.

   See regex.m for doco on how to use it.

   Not particularly efficient for multiple matches.
*/

#include "mex.h"
#include "regex.h"
#include <string.h>

#define mxArray_t mxArray

#define OPTION_STR_LENGTH 50
#define FASTMAP_SIZE 256

mxArray_t *reg_to_matlab_string(char *s, struct re_registers *registers,
				int num)
{
    /* Creates a MATLAB string with register number num in the structure
       regs.  Returns NULL on error (usually memory) */

    int reg_size;
    char *reg_str;
    mxArray_t *out;

    /* Sanity check */
    if ((num >= registers->num_regs) | (num < 0)) {
	mexErrMsgTxt("regex: attempt to access invalid backreference");
	return NULL;
    }

    /* Find out the size of the string */
    reg_size = (registers->end[num] - registers->start[num]);

    /* Allocate, +1 for terminator */
    reg_str = mxCalloc(reg_size+1, sizeof(char));
    if (reg_str == NULL) {
	mexErrMsgTxt("regex: unable to allocate memory for "
		     "reg string");
	return NULL;
    }

    /* Copy it in and add null terminator */
    strncpy(reg_str, s + (registers->start[num]), reg_size);
    reg_str[reg_size+1] = '\0';
    mexPrintf("Register number %d has string \"%s\"\n", num, reg_str);
    out = mxCreateString(reg_str);
    if (out == NULL)
	mexErrMsgTxt("regex: unable to allocate memory for reg array");
    mxFree(reg_str);
    return out;
}

enum reg_output_type { ROT_NONE, ROT_CELL, ROT_INDIVIDUAL };


void mexFunction(int nlhs, mxArray_t *plhs[],
		 int nrhs, const mxArray_t *prhs[])
{
    const mxArray_t *pattern, *string, *option;
    mxArray_t *matched, *cells;
    char option_str[OPTION_STR_LENGTH];
    char *pattern_str, *string_str;
    int res, individual = 0, boolean = 0, pattern_len, string_len, num_regs, i;
    const char *error_msg;
    struct re_registers registers;
    struct re_pattern_buffer pattern_buf;
    char fastmap[FASTMAP_SIZE];

    /* No output arguments: just return */
    if (nlhs == 0) return;

    if (nrhs < 2) mexErrMsgTxt("regex: not enough input arguments");
    
    pattern = prhs[0];
    string = prhs[1];

    if (nrhs == 3) {
	option = prhs[2];
	res = mxGetString(option, option_str, OPTION_STR_LENGTH);
	if (res != 0) mexErrMsgTxt("regex: invalid option argument");

	if (strncmp(option_str, "individual", OPTION_STR_LENGTH) == 0) 
	    individual = 1;
	else if (strncmp(option_str, "boolean", OPTION_STR_LENGTH) == 0) 
	    boolean = 1;
	else mexErrMsgTxt("regex: invalid option argument");
    }

    if (nrhs > 3) mexErrMsgTxt("regex: too many arguments");

    /* Get the pattern string */
    pattern_len = mxGetNumberOfElements(pattern);
    pattern_str = mxCalloc(pattern_len+1, sizeof(char));
    if (pattern_str == NULL)
	mexErrMsgTxt("regex: not enough memory to allocate pattern");

    res = mxGetString(pattern, pattern_str, pattern_len+1);
    if (res != 0)
	mexErrMsgTxt("regex: pattern was not a string");

    mexPrintf("pattern_str (length %d) is \"%s\"\n", pattern_len, pattern_str);

    /* Get the string to match */
    string_len = mxGetNumberOfElements(string);
    string_str = mxCalloc(string_len+1, sizeof(char));
    if (string_str == NULL)
	mexErrMsgTxt("regex: not enough memory to allocate string");

    res = mxGetString(string, string_str, string_len+1);
    if (res != 0) mexErrMsgTxt("regex: second argument was not a string");

    mexPrintf("string_str (length %d) is \"%s\"\n", string_len, string_str);

    /* Set up our regexp buffer */
    pattern_buf.translate = NULL;
    pattern_buf.buffer = NULL;
    pattern_buf.allocated = 0;
    pattern_buf.regs_allocated = REGS_UNALLOCATED;
    pattern_buf.fastmap = fastmap;

    mexPrintf("Compiling regular expression...");

    /* Compile the regular expression */
    error_msg = re_compile_pattern(pattern_str, pattern_len, &pattern_buf);

    if (error_msg != NULL) mexErrMsgTxt(error_msg);

    mexPrintf("done.\n");

    mexPrintf("Searching regular expression...");

    /* Do a search on the regular expression */
    res = re_search(&pattern_buf, string_str, string_len, 0, string_len,
		    &registers);

    if (res == -2) mexErrMsgTxt("regex: internal error in matcher!");

    mexPrintf("done.\n");

    if (boolean) {
	matched = mxCreateDoubleMatrix(1, 1, mxREAL);
	if (matched == NULL)
	    mexErrMsgTxt("regex: unable to allocate matched array");
	
	if (res == -1) { /* Not found */
	    *mxGetPr(matched) = 0.0;
	    mexPrintf("Match was not found\n");
	} else { /* Found */
	    *mxGetPr(matched) = 1.0;
	    mexPrintf("Match was found\n");
	}
	plhs[0] = matched;
    }
    
    else {
	matched = reg_to_matlab_string(string_str, &registers, 0);
	plhs[0] = matched;
    }	

    /* Now, if we were called with LHS arguments, then we need to return
       the contents of the backreference "registers" */

    if (individual) num_regs = nlhs;
    else {
	num_regs = pattern_buf.re_nsub;
	cells = mxCreateCellMatrix(num_regs, 1);
	if (cells == NULL)
	    mexErrMsgTxt("regex: unable to create output cell array");
    }

    mexPrintf("Number of output regs = %d\n", num_regs);

    for (i=0; i<num_regs; i++) {
	mxArray_t *out;

	out = reg_to_matlab_string(string_str, &registers, i);
	if (out == NULL)
	    mexErrMsgTxt("regex: couldn't get register");

	if (individual) plhs[i+1] = out;
	else mxSetCell(cells, i, out);
    }

    if (!individual)
	plhs[1] = cells;

    /* Clean up */
    mexPrintf("Cleaning up registers...");
    mxFree(registers.start);
    mxFree(registers.end);
    mexPrintf("done.\nCleaning up pattern_buf...");
    pattern_buf.fastmap = NULL;
    regfree(&pattern_buf);
    mexPrintf("done.\nCleaning up strings...");
    mxFree(string_str);
    mxFree(pattern_str);
    mexPrintf("done.\n");
}    
    
    
