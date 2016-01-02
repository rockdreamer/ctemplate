cmake_minimum_required(VERSION 2.8)
project(ctemplate C CXX)
option(CTEMPLATE_FORCE_32BITS "Force 32-bit compilation on 64-bit hosts" OFF)
option(CTEMPLATE_BUILD_STATIC "Create a static library instead of a dll" OFF)
option(CTEMPLATE_BOOST_INCLUDE_DIRECTORY "if set, use unordered_map from boost")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")


include ( CheckIncludeFiles )
include ( CheckIncludeFile )
include( AC_HEADER_STDC )
include( AC_CHECK_FUNCS )
ac_check_funcs( getopt_long getopt )
include( AC_CHECK_HEADERS )
ac_check_headers( getopt.h )
ac_check_headers( utime.h)           # used by unittests to mock file-times

# These are the types I need.  We look for them in either stdint.h,
# sys/types.h, or inttypes.h, all of which are part of the default-includes.
include(AC_CHECK_TYPES)
ac_check_types(uint32_t)
ac_check_types(u_int32_t)
ac_check_types(__int32)
ac_check_types(uint64_t)
ac_check_types(u_int64_t)
ac_check_types(__int64)
ac_check_types(size_t)
ac_check_types(int)
ac_check_types(long)
ac_check_types(unsigned long long)
if(HAVE_UINT64_T)
set(ac_cv_uint64 "uint64_t")
elseif(HAVE_U_INT64_T)
set(ac_cv_uint64 "u_int64_t")
elseif(HAVE___INT64)
set(ac_cv_uint64 "unsigned __int64")
else()
set(ac_cv_uint64 "unsigned long long")
endif()

if(WIN32)
	set(ac_cv_formatting_prius_prefix "I")
elseif(${SIZEOF_SIZE_T} STREQUAL ${SIZEOF_INT})
	set(ac_cv_formatting_prius_prefix "")
elseif(${SIZEOF_SIZE_T} STREQUAL ${SIZEOF_LONG})
	set(ac_cv_formatting_prius_prefix "l")
else()
	set(ac_cv_formatting_prius_prefix "ll")
endif()
set(PRIuS "${ac_cv_formatting_prius_prefix}u")
set(PRIxS "${ac_cv_formatting_prius_prefix}x")
set(PRIdS "${ac_cv_formatting_prius_prefix}d")

# We need to do byte-swapping efficiently to hash efficiently in
# template_string.cc.  Different architectures do this differently.
ac_check_headers(byteswap.h)              # Linux (GNU in general)
ac_check_headers(libkern/OSByteOrder.h)   # OS X
ac_check_headers(sys/byteorder.h)         # Solaris 10
ac_check_headers(endian.h)                # Linux
ac_check_headers(machine/endian.h)        # OS X
ac_check_headers(sys/endian.h)            # FreeBSD
ac_check_headers(sys/isa_defs.h)          # Solaris 10

ac_check_headers(stdint.h)
if(HAVE_STDINT_H)
set(ac_cv_have_stdint_h 1)
else()
set(ac_cv_have_stdint_h 0)
endif()

ac_check_headers(inttypes.h)
if(HAVE_INTTYPES_H)
set(ac_cv_have_inttypes_h 1)
else()
set(ac_cv_have_inttypes_h 0)
endif()

include( FindThreads )
if(CMAKE_USE_PTHREADS_INIT)
set(HAVE_PTHREAD 1)
endif()

include(AC_RWLOCK)

include(AC_INTERLOCKED_EXCHANGE_NONVOLATILE)
include(AC_CXX_STL_NAMESPACE)
include(AC_DEFINE_GOOGLE_NAMESPACE)
set(CTEMPLATE_NAMESPACE ctemplate)
ac_define_google_namespace(${CTEMPLATE_NAMESPACE})

include(AC_CXX_STL_HASH)
include(AC_HAVE__ATTRIBUTE__)
include(WEAK_ATTRIBUTE)

if(WIN32)
	set(ac_windows_dllexport "CTEMPLATE_DLL_DECL")
	set(ac_windows_dllexport_defines "#ifndef CTEMPLATE_DLL_DECL\n# define CTEMPLATE_DLL_DECL  __declspec(dllimport)\n#endif")
endif()

set(TMPDIR "${CMAKE_CURRENT_BINARY_DIR}/tmp}")


set(ac_htmlparser_namespace "ctemplate_htmlparser")

# These files are auto-generated via generate_fsm.py.  Since we don't want
# to require python to build ctemplate, we include these in the dist
#src/htmlparser/htmlparser_fsm.h: src/htmlparser/generate_fsm.py src/htmlparser/fsm_config.py src/htmlparser/htmlparser_fsm.config
#	$(top_srcdir)/src/htmlparser/generate_fsm.py $(top_srcdir)/src/htmlparser/htmlparser_fsm.config > $@

#src/htmlparser/jsparser_fsm.h: src/htmlparser/generate_fsm.py src/htmlparser/fsm_config.py src/htmlparser/jsparser_fsm.config
#	$(top_srcdir)/src/htmlparser/generate_fsm.py $(top_srcdir)/src/htmlparser/jsparser_fsm.config > $@

#src/tests/statemachine_test_fsm.h: src/htmlparser/generate_fsm.py src/htmlparser/fsm_config.py src/tests/statemachine_test_fsm.config
#	$(top_srcdir)/src/htmlparser/generate_fsm.py $(top_srcdir)/src/tests/statemachine_test_fsm.config > $@
#BUILT_SOURCES = src/htmlparser/htmlparser_fsm.h \
#                src/htmlparser/jsparser_fsm.h \
#                src/tests/statemachine_test_fsm.h


# These are the symbols (classes, mostly) we want to export from our library.
# Note this regexp applies to the *mangled* name, which is why we have to
# be careful where we want to assert [^A-Za-z].  (Particularly bad on Darwin.)
# template_modifiers and BaseArena and UnsafeArena perhaps shouldn't be
# exported, but they're needed -- at least -- for some unittests.
set(CTEMPLATE_SYMBOLS "(ctemplate|template_modifiers|BaseArena|UnsafeArena|[^A-Za-z]Template[^A-Za-z]|TemplateDictionary|TemplateNamelist|TemplateFromString|TemplateString|TemplateState|[^A-Za-z]Strip[^A-Za-z])")
set(CTEMPLATE_TESTING_SYMBOLS "TemporaryRegisterTemplate|TemplateDictionaryPeer")

if(CMAKE_COMPILER_IS_GNUCC)
set(BASE_COMPILER_FLAGS "-Wall -Wwrite-strings -Woverloaded-virtual -Wno-sign-compare")
if (CTEMPLATE_FORCE_32BITS)
set(BASE_COMPILER_FLAGS "${BASE_COMPILER_FLAGS} -m32")
#set(BASE_LINKER_FLAGS "-export-symbols-regex ${CTEMPLATE_SYMBOLS} -no-undefined")
#set(TESTING_LINKER_FLAGS "-export-symbols-regex ${CTEMPLATE_TESTING_SYMBOLS} -no-undefined")
endif()
endif()
include(CheckCXXCompilerFlag)

CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
endif()
if(CMAKE_CXX_COMPILER_ID STREQUAL "XL")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -D__IBMCPP_TR1__")
endif()


# Update this value for every release!  (A:B:C will map to foo.so.(A-C).C.B)
# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
set(CTEMPLATE_VERSION 2.3.0)
set(CTEMPLATE_SOVERSION 3.0.0)
set(CTEMPLATE_LIB_INSTALL_DIRECTORY lib)
set(VERSION ${CTEMPLATE_VERSION})
set(PACKAGE_STRING "ctemplate ${VERSION}")
list(APPEND CTEMPLATE_IN_HEADERS
	ctemplate/find_ptr.h
	ctemplate/per_expand_data.h 
	ctemplate/str_ref.h 
	ctemplate/template.h 
	ctemplate/template_annotator.h 
	ctemplate/template_cache.h 
	ctemplate/template_dictionary.h 
	ctemplate/template_dictionary_interface.h
	ctemplate/template_emitter.h 
	ctemplate/template_enums.h 
	ctemplate/template_modifiers.h 
	ctemplate/template_namelist.h 
	ctemplate/template_pathops.h 
	ctemplate/template_string.h
)

foreach(CURRENT_HEADER IN ITEMS ${CTEMPLATE_IN_HEADERS})
	configure_file(src/${CURRENT_HEADER}.in src/${CURRENT_HEADER})
	LIST(APPEND CTEMPLATE_HDRS src/${CURRENT_HEADER})
endforeach()
configure_file(src/config.h.cmake src/config.h)
LIST(APPEND CTEMPLATE_HDRS src/config.h)


LIST(APPEND CTEMPLATE_HDRS
	src/indented_writer.h
	src/template_modifiers_internal.h
	src/base/arena-inl.h
	src/base/arena.h
	src/base/fileutil.h
	src/base/macros.h
	src/base/manual_constructor.h
	src/base/mutex.h
	src/base/small_map.h
	src/base/thread_annotations.h
	src/base/util.h
	src/htmlparser/htmlparser.h
	src/htmlparser/htmlparser_cpp.h
	#src/htmlparser/htmlparser_fsm.h
	src/htmlparser/jsparser.h
	#src/htmlparser/jsparser_fsm.h
	src/htmlparser/statemachine.h
	src/ctemplate/str_ref.h
)

if (WIN32)
	list(APPEND CTEMPLATE_HDRS src/windows/port.h	)
endif()

include_directories(src)
include_directories(prebuilt_fsms)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)
if (CTEMPLATE_BOOST_INCLUDE_DIRECTORY)

	include_directories(${CTEMPLATE_BOOST_INCLUDE_DIRECTORY})

endif()


list(APPEND CTEMPLATE_SRCS
src/per_expand_data.cc
src/template.cc
src/template_annotator.cc
src/template_cache.cc
src/template_dictionary.cc
src/template_modifiers.cc
src/template_namelist.cc
src/template_pathops.cc
src/template_string.cc
src/base/arena.cc
src/htmlparser/htmlparser.cc
src/htmlparser/jsparser.cc
src/htmlparser/statemachine.cc
)

if (WIN32)
	list(APPEND CTEMPLATE_SRCS	src/windows/port.cc	)
endif()

if (CTEMPLATE_BUILD_STATIC)
add_library(ctemplate STATIC ${CTEMPLATE_SRCS} ${CTEMPLATE_HDRS})
else()
add_library(ctemplate SHARED ${CTEMPLATE_SRCS} ${CTEMPLATE_HDRS})
endif()
target_link_libraries(ctemplate ${CMAKE_THREAD_LIBS_INIT})
set_target_properties(ctemplate 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${BASE_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)

add_library(ctemplate_nothreads SHARED ${CTEMPLATE_SRCS} ${CTEMPLATE_HDRS})
set_target_properties(ctemplate_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${BASE_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)

add_executable(make_tpl_varnames_h src/make_tpl_varnames_h.cc)
target_link_libraries(make_tpl_varnames_h ctemplate_nothreads)

add_executable(diff_tpl_auto_escape src/diff_tpl_auto_escape.cc)
target_link_libraries(diff_tpl_auto_escape ctemplate_nothreads)

install(TARGETS ctemplate make_tpl_varnames_h diff_tpl_auto_escape
	RUNTIME DESTINATION bin
	ARCHIVE DESTINATION ${CTEMPLATE_LIB_INSTALL_DIRECTORY}
	LIBRARY DESTINATION ${CTEMPLATE_LIB_INSTALL_DIRECTORY}
)

install(
	FILES ${CTEMPLATE_HDRS}
	DESTINATION include/ctemplate
)

#docdir = $(prefix)/share/doc/$(PACKAGE)-$(VERSION)
## This is for HTML and other documentation you want to install.
## Add your documentation files (in doc/) in addition to these
## top-level boilerplate files.  Also add a TODO file if you have one.
#dist_doc_DATA = AUTHORS COPYING ChangeLog INSTALL NEWS README README_windows.txt \
#	doc/designstyle.css doc/index.html \
#	doc/howto.html doc/guide.html doc/reference.html \
#	doc/tips.html doc/example.html doc/auto_escape.html \
#	doc/xss_resources.html


# We could also make a library that has the TemplateDictionaryPeer
# class.  This class is useful for testing (it provides introspection
# on the TemplateDictionary hierarchy that's easier to use than the
# default debugging method, TemplateDictionary::Dump()) but by the
# same token also violates abstraction in ways that might be fragile.
# We don't expose the library for now, until the demonstrated need
# outweighs the costs.  If you'd like to use this library, please send
# mail to google-ctemplate@googlegroups.com!
add_library(ctemplate_testing STATIC 
	src/tests/template_test_util.h
	src/tests/template_test_util.cc
)
target_link_libraries(ctemplate_testing ctemplate)
set_target_properties(ctemplate_testing 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)

add_library(ctemplate_testing_nothreads STATIC 
	src/tests/template_test_util.h
	src/tests/template_test_util.cc
)
target_link_libraries(ctemplate_testing_nothreads ctemplate_nothreads)
set_target_properties(ctemplate_testing_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)

enable_testing()
# when running tests, we must export this under the environment
set(CTEST_ENVIRONMENT
"TEMPLATE_ROOTDIR=${CMAKE_CURRENT_SOURCE_DIR}/")

######## Compile Tests #######
add_executable(compile_test 
	src/tests/config_for_unittests.h
	src/tests/compile_test.cc
)
target_link_libraries(compile_test ctemplate_testing)
set_target_properties(compile_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( compile_test_1 compile_test)

add_executable(compile_test_nothreads 
	src/tests/config_for_unittests.h
	src/tests/compile_test.cc
)
target_link_libraries(compile_test_nothreads ctemplate_testing_nothreads)
set_target_properties(compile_test_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( compile_test_nothreads_1 compile_test_nothreads)

######## Template Test Utils Tests #######
add_executable(template_test_util_test 
	src/tests/config_for_unittests.h
	src/tests/template_test_util_test.cc
)
target_link_libraries(template_test_util_test ctemplate_testing)
set_target_properties(template_test_util_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_test_util_test_1 template_test_util_test)

add_executable(template_test_util_test_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_test_util_test.cc
)
target_link_libraries(template_test_util_test_nothreads ctemplate_testing_nothreads)
set_target_properties(template_test_util_test_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_test_util_test_nothreads_1 template_test_util_test_nothreads)

######## Template Dictionary Tests #######
add_executable(template_dictionary_unittest 
	src/tests/config_for_unittests.h
	src/tests/template_dictionary_unittest.cc
)
target_link_libraries(template_dictionary_unittest ctemplate_testing)
set_target_properties(template_dictionary_unittest 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_dictionary_unittest_1 template_dictionary_unittest)

add_executable(template_dictionary_unittest_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_dictionary_unittest.cc
)
target_link_libraries(template_dictionary_unittest_nothreads ctemplate_testing_nothreads)
set_target_properties(template_dictionary_unittest_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_dictionary_unittest_nothreads_1 template_dictionary_unittest_nothreads)

######## Template Modifiers Tests #######
add_executable(template_modifiers_unittest 
	src/tests/config_for_unittests.h
	src/tests/template_modifiers_unittest.cc
)
target_link_libraries(template_modifiers_unittest ctemplate_testing)
set_target_properties(template_modifiers_unittest 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_modifiers_unittest_1 template_modifiers_unittest)

add_executable(template_modifiers_unittest_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_modifiers_unittest.cc
)
target_link_libraries(template_modifiers_unittest_nothreads ctemplate_testing_nothreads)
set_target_properties(template_modifiers_unittest_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_modifiers_unittest_nothreads_1 template_modifiers_unittest_nothreads)

######## Template set globals Tests #######
add_executable(template_setglobals_unittest 
	src/tests/config_for_unittests.h
	src/tests/template_setglobals_unittest.cc
)
target_link_libraries(template_setglobals_unittest ctemplate_testing)
set_target_properties(template_setglobals_unittest 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_setglobals_unittest_1 template_setglobals_unittest)

add_executable(template_setglobals_unittest_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_setglobals_unittest.cc
)
target_link_libraries(template_setglobals_unittest_nothreads ctemplate_testing_nothreads)
set_target_properties(template_setglobals_unittest_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_setglobals_unittest_nothreads_1 template_setglobals_unittest_nothreads)

######## Template cache Tests #######
add_executable(template_cache_test 
	src/tests/config_for_unittests.h
	src/tests/template_cache_test.cc
)
target_link_libraries(template_cache_test ctemplate_testing)
set_target_properties(template_cache_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_cache_test_1 template_cache_test)

add_executable(template_cache_test_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_cache_test.cc
)
target_link_libraries(template_cache_test_nothreads ctemplate_testing_nothreads)
set_target_properties(template_cache_test_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_cache_test_nothreads_1 template_cache_test_nothreads)

########### TEMPLATE UNIT TESTS ##############
add_executable(template_unittest 
	src/tests/config_for_unittests.h
	src/tests/template_unittest.cc
)
target_link_libraries(template_unittest ctemplate_testing)
set_target_properties(template_unittest 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_unittest_1 template_unittest)

add_executable(template_unittest_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_unittest.cc
)
target_link_libraries(template_unittest_nothreads ctemplate_testing_nothreads)
set_target_properties(template_unittest_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_unittest_nothreads_1 template_unittest_nothreads)

########### TEMPLATE REG TESTS ##############
add_executable(template_regtest 
	src/tests/config_for_unittests.h
	src/tests/template_regtest.cc
)
target_link_libraries(template_regtest ctemplate_testing)
set_target_properties(template_regtest 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( template_regtest_1 template_regtest
   src/tests/template_unittest_test_footer.in 
   src/tests/template_unittest_test_html.in 
   src/tests/template_unittest_test_invalid1.in 
   src/tests/template_unittest_test_invalid2.in 
   src/tests/template_unittest_test_markerdelim.in 
   src/tests/template_unittest_test_modifiers.in 
   src/tests/template_unittest_test_nul.in 
   src/tests/template_unittest_test_selective_css.in 
   src/tests/template_unittest_test_selective_html.in 
   src/tests/template_unittest_test_selective_js.in 
   src/tests/template_unittest_test_simple.in 
   src/tests/template_unittest_test_valid1.in 
   src/tests/template_unittest_test_footer_dict01.out 
   src/tests/template_unittest_test_footer_dict02.out 
   src/tests/template_unittest_test_html_dict01.out 
   src/tests/template_unittest_test_html_dict02.out 
   src/tests/template_unittest_test_markerdelim_dict01.out 
   src/tests/template_unittest_test_markerdelim_dict02.out 
   src/tests/template_unittest_test_modifiers_dict01.out 
   src/tests/template_unittest_test_nul_dict01.out 
   src/tests/template_unittest_test_selective_css_dict01.out 
   src/tests/template_unittest_test_selective_css_dict02.out 
   src/tests/template_unittest_test_selective_html_dict01.out
   src/tests/template_unittest_test_selective_html_dict02.out 
   src/tests/template_unittest_test_selective_js_dict01.out 
   src/tests/template_unittest_test_selective_js_dict02.out 
   src/tests/template_unittest_test_simple_dict01.out 
   src/tests/template_unittest_test_simple_dict02.out 
   src/tests/template_unittest_test_simple_dict03.out
   src/tests/template_unittest_test_valid1_dict01.out
)

add_executable(template_regtest_nothreads 
	src/tests/config_for_unittests.h
	src/tests/template_regtest.cc
)
target_link_libraries(template_regtest_nothreads ctemplate_testing_nothreads)
set_target_properties(template_regtest_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( template_regtest_nothreads_1 template_regtest_nothreads
   src/tests/template_unittest_test_footer.in 
   src/tests/template_unittest_test_html.in 
   src/tests/template_unittest_test_invalid1.in 
   src/tests/template_unittest_test_invalid2.in 
   src/tests/template_unittest_test_markerdelim.in 
   src/tests/template_unittest_test_modifiers.in 
   src/tests/template_unittest_test_nul.in 
   src/tests/template_unittest_test_selective_css.in 
   src/tests/template_unittest_test_selective_html.in 
   src/tests/template_unittest_test_selective_js.in 
   src/tests/template_unittest_test_simple.in 
   src/tests/template_unittest_test_valid1.in 
   src/tests/template_unittest_test_footer_dict01.out 
   src/tests/template_unittest_test_footer_dict02.out 
   src/tests/template_unittest_test_html_dict01.out 
   src/tests/template_unittest_test_html_dict02.out 
   src/tests/template_unittest_test_markerdelim_dict01.out 
   src/tests/template_unittest_test_markerdelim_dict02.out 
   src/tests/template_unittest_test_modifiers_dict01.out 
   src/tests/template_unittest_test_nul_dict01.out 
   src/tests/template_unittest_test_selective_css_dict01.out 
   src/tests/template_unittest_test_selective_css_dict02.out 
   src/tests/template_unittest_test_selective_html_dict01.out
   src/tests/template_unittest_test_selective_html_dict02.out 
   src/tests/template_unittest_test_selective_js_dict01.out 
   src/tests/template_unittest_test_selective_js_dict02.out 
   src/tests/template_unittest_test_simple_dict01.out 
   src/tests/template_unittest_test_simple_dict02.out 
   src/tests/template_unittest_test_simple_dict03.out
   src/tests/template_unittest_test_valid1_dict01.out
)

########### HTMLPARSER C++ TESTS ##############
add_executable(htmlparser_test 
	src/tests/config_for_unittests.h
	src/tests/htmlparser_cpp_test.cc
)
target_link_libraries(htmlparser_test ctemplate_testing)
set_target_properties(htmlparser_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( htmlparser_test_1 htmlparser_test
   src/tests/htmlparser_testdata/cdata.html 
   src/tests/htmlparser_testdata/comments.html 
   src/tests/htmlparser_testdata/context.html 
   src/tests/htmlparser_testdata/google.html 
   src/tests/htmlparser_testdata/javascript_attribute.html 
   src/tests/htmlparser_testdata/javascript_block.html 
   src/tests/htmlparser_testdata/javascript_regexp.html 
   src/tests/htmlparser_testdata/position.html 
   src/tests/htmlparser_testdata/reset.html 
   src/tests/htmlparser_testdata/simple.html 
   src/tests/htmlparser_testdata/tags.html
)

add_executable(htmlparser_test_nothreads 
	src/tests/config_for_unittests.h
	src/tests/htmlparser_cpp_test.cc
)
target_link_libraries(htmlparser_test_nothreads ctemplate_testing_nothreads)
set_target_properties(htmlparser_test_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)
add_test( htmlparser_test_nothreads_1 htmlparser_test_nothreads
   src/tests/htmlparser_testdata/cdata.html 
   src/tests/htmlparser_testdata/comments.html 
   src/tests/htmlparser_testdata/context.html 
   src/tests/htmlparser_testdata/google.html 
   src/tests/htmlparser_testdata/javascript_attribute.html 
   src/tests/htmlparser_testdata/javascript_block.html 
   src/tests/htmlparser_testdata/javascript_regexp.html 
   src/tests/htmlparser_testdata/position.html 
   src/tests/htmlparser_testdata/reset.html 
   src/tests/htmlparser_testdata/simple.html 
   src/tests/htmlparser_testdata/tags.html
)

########### HTMLPARSER C TESTS ##############
# We want to compile statemachine.cc as a c file as well as a c++ file
configure_file(src/htmlparser/statemachine.cc src/htmlparser/statemachine.c COPYONLY)
add_executable(statemachine_test 
	src/tests/statemachine_test.c
	${CMAKE_CURRENT_BINARY_DIR}/src/htmlparser/statemachine.c
)
set_target_properties(statemachine_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( statemachine_test_1 statemachine_test)
