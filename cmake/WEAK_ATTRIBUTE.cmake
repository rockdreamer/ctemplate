try_compile(
	WEAK_ATTRIBUTE_RUNS
	${CMAKE_BINARY_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/weak_attribute.cpp
)

if(WEAK_ATTRIBUTE_RUNS)
	set(ac_have_attribute_weak 1)
else()
	set(ac_have_attribute_weak 0)
endif()