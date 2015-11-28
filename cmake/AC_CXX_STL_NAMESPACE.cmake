try_compile(
	STL_LIVES_UNDER_NO_NAMESPACE
	${CMAKE_BINARY_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/ac_cxx_stl_no_namespace.cpp
)
try_compile(
	STL_LIVES_UNDER_STD_NAMESPACE
	${CMAKE_BINARY_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/ac_cxx_stl_std_namespace.cpp
)

if (STL_LIVES_UNDER_STD_NAMESPACE)
	message(STATUS "STL is present under std namespace")
	set(STL_NAMESPACE "std")
	set(ac_cv_cxx_stl_namespace "std")
elseif (STL_LIVES_UNDER_NO_NAMESPACE)
	message(STATUS "STL is present without std namespace")
	set(STL_NAMESPACE "")
	set(ac_cv_cxx_stl_namespace "")
else()
	message(FATAL_ERROR "Cannot compile a simple program using vector")
endif()
