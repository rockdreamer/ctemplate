# Check whether InterlockedExchange() takes a LONG or a volatile LONG
# as its first argument.  InterlockedCompareExchange is a windows
# function; obviously, this macro is useful only for cygwin and mingw,
# and other systems that compile against the windows API.
#
# Apparently the interface for this function is a bit inconsistent.
# Windows likes volatile LONG, but mingw and cygwin don't, at least
# for the versions I'm using.  But rather than try to guess who
# supports what, let's just check at configure time.  (Note: this
# is an error in C++ but only a warning in C, so we test in the former.)
#
# This function returns 'yes' if the type does not need volatile,
# and defines the symbol INTERLOCKED_EXCHANGE_NONVOLATILE.  (This
# is the expected case for mingw and cygwin).  It returns 'no',
# and defines no symbol, otherwise.  (This is the expected case for
# MSVC.)  The return value was sset this way so that we don't need
# to define any symbols on windows, which doesn't run configure.
if(WIN32)
	try_compile(
		INTERLOCKED_EXCHANGE_VOLATILE
		${CMAKE_BINARY_DIR}
		${CMAKE_CURRENT_SOURCE_DIR}/cmake/ac_interlocked_exchange.cpp
	)

	if (INTERLOCKED_EXCHANGE_VOLATILE)
		message(STATUS "InterlockedExchange accepts volatile long")
		set(INTERLOCKED_EXCHANGE_NONVOLATILE FALSE)
	else()
		message(STATUS "InterlockedExchange does not accept volatile long")
		set(INTERLOCKED_EXCHANGE_NONVOLATILE TRUE)
	endif()
endif()