"Usage: matlabscript [options] command [command ...]\n"
"\n"
"Information, version and license:\n"
" -h | --help           Print this message and exit\n"
" -v | --version        Print version number and exit\n"
" -l | --license        Print program license and exit\n"
"\n"
"Command options (may be specified multiple times):\n"
" -f | --run-file <filename>\n"
"                       Run commands from <filename> sequentially\n"
" -c | --run-command <command>\n"
"                       Run the MATLAB command <command>\n"
"\n"
"Output options:\n"
" -q | --quiet          Print nothing\n"
" -V | --verbose        Print everything\n"
" -d | --debug          Print debugging messages\n"
" -C | --dont-print-commands\n"
"                       Don't print command names as they are executed\n"
" -b | --output-buffer-size <size>\n"
"                       Use <size> bytes to buffer MATLAB's output (def 64k)\n"
"\n"
"Miscellaneous:\n"
" -o | --engine-options <string>\n"
"                       Use <string> to start up MATLAB\n"