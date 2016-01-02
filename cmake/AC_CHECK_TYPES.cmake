# check if type exists
include(CheckTypeSize)
macro (ac_check_types _TYPES)
	foreach (it ${_TYPES})
		string(REGEX REPLACE "[/.]" "_" _it "${it}")
		string(TOUPPER "${_it}" _it)
		check_type_size ("${it}" "SIZEOF_${_it}")
		if( "${SIZEOF_${_it}}" STREQUAL "")
#			message(STATUS "${it} - does not exist")
		else ()
#			message(STATUS "${it} - exists (size ${SIZEOF_${_it}}), setting HAVE_${_it}")
			set(HAVE_${_it} 1)
		endif()
	endforeach (it)
endmacro(ac_check_types)
