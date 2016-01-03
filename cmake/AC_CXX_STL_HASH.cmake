include(CheckCXXCompilerFlag)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.2.0")
  	set(HAVE_OLD_GNUC_FOR_UNORDERED_MAP_SET TRUE)
  else()
    CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
    CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
    if(COMPILER_SUPPORTS_CXX11)
        set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    elseif(COMPILER_SUPPORTS_CXX0X)
        set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    else()
    endif()
  endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "SunPro")
    CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
    if(COMPILER_SUPPORTS_CXX11)
        set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
    if(COMPILER_SUPPORTS_CXX11)
        set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "XL")
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS}  -D__IBMCPP_TR1__")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS}")
else()
    message(STATUS "Unknown compiler ID ${CMAKE_CXX_COMPILER_ID}")
endif()


include(CheckIncludeFileCXX)
include(CheckCXXSymbolExists)
set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS FALSE)

if (CTEMPLATE_BOOST_INCLUDE_DIRECTORY)
list(APPEND CMAKE_REQUIRED_INCLUDES ${CTEMPLATE_BOOST_INCLUDE_DIRECTORY})
 check_cxx_source_compiles("#include <boost/unordered_map.hpp>
                                 int main() {
                                   boost::unordered_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STD_UNORDERED_MAP)
 if((HAVE_STD_UNORDERED_MAP) AND (NOT (HAVE_OLD_GNUC_FOR_UNORDERED_MAP_SET)))
	set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
	set(HAVE_HASH_SET)
	set(HASH_MAP_H "<boost/unordered_map.hpp>")
	set(HASH_SET_H "<boost/unordered_set.hpp>")
	set(ac_cv_cxx_hash_map "<boost/unordered_map.hpp>")
	set(ac_cv_cxx_hash_set "<boost/unordered_set.hpp>")
	set(HASH_NAMESPACE "boost")
	set(HAVE_UNORDERED_MAP TRUE)
	set(ac_cv_cxx_hash_map_class "boost::unordered_map")
	set(ac_cv_cxx_hash_set_class "boost::unordered_set")
	message( STATUS "Unordered stl container is boost::unordered_map from boost headers installed in ${CTEMPLATE_BOOST_INCLUDE_DIRECTORY}")
endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
 check_cxx_source_compiles("#include <unordered_map>
                                 int main() {
                                   std::unordered_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STD_UNORDERED_MAP)
 if((HAVE_STD_UNORDERED_MAP) AND (NOT (HAVE_OLD_GNUC_FOR_UNORDERED_MAP_SET)))
	set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
	set(HAVE_HASH_SET)
	set(HASH_MAP_H "<unordered_map>")
	set(HASH_SET_H "<unordered_set>")
	set(ac_cv_cxx_hash_map "<unordered_map>")
	set(ac_cv_cxx_hash_set "<unordered_set>")
	set(HASH_NAMESPACE "std")
	set(HAVE_UNORDERED_MAP TRUE)
	set(ac_cv_cxx_hash_map_class "std::unordered_map")
	set(ac_cv_cxx_hash_set_class "std::unordered_set")
	message( STATUS "Unordered stl container is std::unordered_map")
endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <unordered_map>
                                 int main() {
                                   std::tr1::unordered_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STD_TR1_UNORDERED_MAP)
	if(HAVE_STD_TR1_UNORDERED_MAP)
		set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
		set(HASH_MAP_H "<unordered_map>")
		set(HASH_SET_H "<unordered_set>")
		set(ac_cv_cxx_hash_map "<unordered_map>")
		set(ac_cv_cxx_hash_set "<unordered_set>")
		set(HASH_NAMESPACE "std::tr1")
		set(HAVE_UNORDERED_MAP TRUE)
		set(ac_cv_cxx_hash_map_class "std::tr1::unordered_map")
		set(ac_cv_cxx_hash_set_class "std::tr1::unordered_set")
		message( STATUS "Unordered stl container is std::tr1::unordered_map in unordered_map header")
	endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <tr1/unordered_map>
                                 int main() {
                                   std::tr1::unordered_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STD_TR1_UNORDERED_MAP)
        if(HAVE_STD_TR1_UNORDERED_MAP)
                set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
                set(HASH_MAP_H "<tr1/unordered_map>")
                set(HASH_SET_H "<tr1/unordered_set>")
                set(ac_cv_cxx_hash_map "<tr1/unordered_map>")
                set(ac_cv_cxx_hash_set "<tr1/unordered_set>")
                set(HASH_NAMESPACE "std::tr1")
                set(HAVE_UNORDERED_MAP TRUE)
                set(ac_cv_cxx_hash_map_class "std::tr1::unordered_map")
                set(ac_cv_cxx_hash_set_class "std::tr1::unordered_set")
                message( STATUS "Unordered stl container is std::tr1::unordered_mapin tr1/unordered_map header")
        endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <hash_map>
                                 int main() {
                                   __gnu_cxx::hash_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_GNU__CXX_HASH_MAP)
	if(HAVE_GNU__CXX_HASH_MAP)
		set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
		set(HAVE_HASH_SET TRUE)
		set(HASH_MAP_H "<hash_map>")
		set(HASH_SET_H "<hash_set>")
		set(ac_cv_cxx_hash_map "<hash_map>")
		set(ac_cv_cxx_hash_set "<hash_set>")
		set(HASH_NAMESPACE "__gnu_cxx")
		set(ac_cv_cxx_hash_map_class "__gnu_cxx::hash_map")
		set(ac_cv_cxx_hash_set_class "__gnu_cxx::hash_set")
		message( STATUS "Unordered stl container is __gnu_cxx::hash_map")
	endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <ext/hash_map>
                                 int main() {
                                   __gnu_cxx::hash_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_GNU_EXT_CXX_HASH_MAP)
       if(HAVE_GNU_EXT_CXX_HASH_MAP)
               set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
               set(HAVE_HASH_SET TRUE)
               set(HASH_MAP_H "<ext/hash_map>")
               set(HASH_SET_H "<ext/hash_set>")
               set(ac_cv_cxx_hash_map "<ext/hash_map>")
               set(ac_cv_cxx_hash_set "<ext/hash_set>")
               set(HASH_NAMESPACE "__gnu_cxx")
               set(ac_cv_cxx_hash_map_class "__gnu_cxx::hash_map")
               set(ac_cv_cxx_hash_set_class "__gnu_cxx::hash_set")
               message( STATUS "Unordered stl container is __gnu_cxx::hash_map")
       endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <hash_map>
                                 int main() {
                                   std::hash_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STD_HASH_MAP)
	if(HAVE_STD_HASH_MAP)
		set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
		set(HAVE_HASH_SET TRUE)
		set(HASH_MAP_H "<hash_map>")
		set(HASH_SET_H "<hash_set>")
		set(ac_cv_cxx_hash_map "<hash_map>")
		set(ac_cv_cxx_hash_set "<hash_set>")
		set(HASH_NAMESPACE "std")
		set(ac_cv_cxx_hash_map_class "std::hash_map")
		set(ac_cv_cxx_hash_set_class "std::hash_set")
		message( STATUS "Unordered stl container is std::hash_map")
	endif()
endif()


if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
   check_cxx_source_compiles("#include <ext/hash_map>
                                 int main() {
                                   stdext::hash_map<int, int> map;
                                   return 0;
                                 }"
                                 HAVE_STDEXT_HASH_MAP)
	if(HAVE_STDEXT_HASH_MAP)
		set(HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS TRUE)
		set(HAVE_HASH_SET TRUE)
		set(HASH_MAP_H "<ext/hash_map>")
		set(HASH_SET_H "<ext/hash_set>")
		set(ac_cv_cxx_hash_map "<ext/hash_map>")
		set(ac_cv_cxx_hash_set "<ext/hash_set>")
		set(HASH_NAMESPACE "stdext")
		set(ac_cv_cxx_hash_map_class "stdext::hash_map")
		set(ac_cv_cxx_hash_set_class "stdext::hash_set")
		message( STATUS "Unordered stl container is stdext::hash_map")
	endif()
endif()

if( NOT HAVE_SOME_SORT_OF_UNORDERED_CONTAINERS)
	message( FATAL_ERROR "Cannot find suitable unordered stl container")
endif()
