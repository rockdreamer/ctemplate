# check for list of headers, ;-separated. For every existing header.h
# the HAVE_HEADER_H became defined as 1
include (CheckIncludeFile)
macro (ac_check_headers _HEADERS)
	foreach (it ${_HEADERS})
		string(REGEX REPLACE "[/.]" "_" _it "${it}")
		string(TOUPPER "${_it}" _it)
		check_include_file ("${it}" "HAVE_${_it}")
	endforeach (it)
endmacro(ac_check_headers)
