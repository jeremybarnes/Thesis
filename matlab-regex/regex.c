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
#define MATLAB_REGEX_SYNTAX RE_INTERVALS | RE_CHAR_CLASSES \
                          | RE_NO_BK_PARENS | RE_NO_BK_BRACES \
                          | RE_NO_BK_VBAR | RE_BACKSLASH_ESCAPE_IN_LISTS

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
	out = mxCreateString("\0");
	if (out == NULL)
	    mexErrMsgTxt("regex: couldn't create empty string");
	return out;
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
    int res, boolean = 0, individual = 0, pattern_len, string_len, i;
    const char *error_msg;
    struct re_registers registers;
    struct re_pattern_buffer pattern_buf;
    char fastmap[FASTMAP_SIZE];
    enum reg_output_type output_type;
    int current_arg;

    /* No output arguments: just return */
    if (nlhs == 0) return;

    if (nrhs < 2) mexErrMsgTxt("regex: not enough input arguments");
    
    pattern = prhs[0];
    string = prhs[1];

    current_arg = 2;

    while (current_arg < nrhs) {
	/* Process all of the options */
	option = prhs[current_arg];
	res = mxGetString(option, option_str, OPTION_STR_LENGTH);
	if (res != 0) mexErrMsgTxt("regex: invalid option argument");

	if (strncmp(option_str, "individual", OPTION_STR_LENGTH) == 0) 
	    individual = 1;
	else if (strncmp(option_str, "boolean", OPTION_STR_LENGTH) == 0) 
	    boolean = 1;
	else mexErrMsgTxt("regex: invalid option argument");

	current_arg++;
    }

    /* Act on our options */
    output_type = ROT_NONE;

    if (!boolean) { /* [match, cells] | [match, reg1, reg2, ...] */
	if (nlhs == 1) output_type = ROT_NONE;
	else if (nlhs == 2) output_type = ROT_CELL;
	else if (nlhs > 2) output_type = ROT_INDIVIDUAL;
    } else {
	if (nlhs == 2) output_type = ROT_NONE;
	else if (nlhs == 3) output_type = ROT_CELL;
	else if (nlhs > 3) output_type = ROT_INDIVIDUAL;
    }

    if (individual) output_type = ROT_INDIVIDUAL;

    /* Get the pattern string */
    pattern_len = mxGetNumberOfElements(pattern);
    pattern_str = mxCalloc(pattern_len+1, sizeof(char));
    if (pattern_str == NULL)
	mexErrMsgTxt("regex: not enough memory to allocate pattern");

    res = mxGetString(pattern, pattern_str, pattern_len+1);
    if (res != 0)
	mexErrMsgTxt("regex: pattern was not a string");

    /* Get the string to match */
    string_len = mxGetNumberOfElements(string);
    string_str = mxCalloc(string_len+1, sizeof(char));
    if (string_str == NULL)
	mexErrMsgTxt("regex: not enough memory to allocate string");

    res = mxGetString(string, string_str, string_len+1);
    if (res != 0) mexErrMsgTxt("regex: second argument was not a string");

    /* Set up our regexp buffer */
    pattern_buf.translate = NULL;
    pattern_buf.buffer = NULL;
    pattern_buf.allocated = 0;
    pattern_buf.regs_allocated = REGS_UNALLOCATED;
    pattern_buf.fastmap = fastmap;
    re_set_syntax(MATLAB_REGEX_SYNTAX);
    registers.num_regs = 0;

    /* Compile the regular expression */
    error_msg = re_compile_pattern(pattern_str, pattern_len, &pattern_buf);

    if (error_msg != NULL) mexErrMsgTxt(error_msg);

    /* Do a search on the regular expression */
    res = re_search(&pattern_buf, string_str, string_len, 0, string_len,
		    &registers);

    if (res == -2) mexErrMsgTxt("regex: internal error in matcher!");

    current_arg = 0;

    if (boolean) {
	/* If boolean is set, then the very first output arg is a boolean
	   value. */
	
	matched = mxCreateDoubleMatrix(1, 1, mxREAL);
	if (matched == NULL)
	    mexErrMsgTxt("regex: unable to allocate matched array");
	
	if (res == -1) { /* Not found */
	    *mxGetPr(matched) = 0.0;
	} else { /* Found */
	    *mxGetPr(matched) = 1.0;
	}
	plhs[current_arg++] = matched;
    }

    /* Next output argument is the matched string */
    if (current_arg < nlhs) {
	matched = reg_to_matlab_string(string_str, &registers, 0);
	plhs[current_arg++] = matched;
    }	

    /* The rest of the output arguments are the registers */
    if (output_type == ROT_CELL) {
	int num_regs = pattern_buf.re_nsub;

	if (current_arg >= nlhs)
	    mexErrMsgTxt("regex: Not enough output arguments for cell array");

	/* Cell matrix: create and populate */
	cells = mxCreateCellMatrix(num_regs, 1);
	if (cells == NULL)
	    mexErrMsgTxt("regex: unable to create output cell array");

	/* Populate */
	for (i=1; i<=num_regs; i++) {
	    mxArray_t *out;

	    out = reg_to_matlab_string(string_str, &registers, i);
	    if (out == NULL)
		mexErrMsgTxt("regex: couldn't get register");

	    else mxSetCell(cells, i-1, out);
	}

	plhs[current_arg++] = cells;
    }

    else if (output_type == ROT_INDIVIDUAL) {
	/* Individual: fill in output arguments until we run out of
	   them or things to put in them */

	int num_regs = pattern_buf.re_nsub, current_reg = 1;

	while ((current_arg < nlhs) && (current_reg <= num_regs)) {
	    mxArray_t *out;

	    out = reg_to_matlab_string(string_str, &registers, current_reg);
	    if (out == NULL)
		mexErrMsgTxt("regex: couldn't get register");

	    else plhs[current_arg] = out;
	    current_reg++;
	    current_arg++;
	}
	
	/* If there are more output arguments, make them the empty string */
	while (current_arg < nlhs) {
	    mxArray_t *out;

	    out = mxCreateString("\0");
	    if (out == NULL)
		mexErrMsgTxt("regex: couldn't create empty string");
	    

	    plhs[current_arg++] = out;
	}
    }

    /* Cause an error if there are the wrong number of output arguments */
    if (current_arg != nlhs)
	mexErrMsgTxt("regex: too many output arguments");


    /* Clean up */
    if (registers.num_regs > 0) {
	mxFree(registers.start);	
	mxFree(registers.end);
    }

    if (pattern_buf.buffer != NULL)
	mxFree(pattern_buf.buffer);
    pattern_buf.buffer = NULL;

    mxFree(string_str);
    mxFree(pattern_str);
}    
    
    
