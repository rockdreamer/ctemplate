# check for list of functions, ;-separated. For every existing
# function the HAVE_FUNCION became defined as 1
include (CheckFunctionExists)
macro (ac_check_funcs _FUNCTIONS)
	foreach (it ${_FUNCTIONS})
		string(TOUPPER "${it}" _it)
		check_function_exists ("${it}" "HAVE_${_it}")
	endforeach(it)
endmacro(ac_check_funcs)
