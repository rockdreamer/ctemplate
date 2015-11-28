if("${CMAKE_THREAD_LIBS_INIT}" STREQUAL "")
try_compile(
	HAVE_RWLOCK
	${CMAKE_BINARY_DIR}/ac_rwlock_test
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/ac_rwlock.c
)
else()
try_compile(
	HAVE_RWLOCK
	${CMAKE_BINARY_DIR}/ac_rwlock_test
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/ac_rwlock.c
	LINK_LIBRARIES ${CMAKE_THREAD_LIBS_INIT}
)
endif()