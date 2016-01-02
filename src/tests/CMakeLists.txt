# We could also make a library that has the TemplateDictionaryPeer
# class.  This class is useful for testing (it provides introspection
# on the TemplateDictionary hierarchy that's easier to use than the
# default debugging method, TemplateDictionary::Dump()) but by the
# same token also violates abstraction in ways that might be fragile.
# We don't expose the library for now, until the demonstrated need
# outweighs the costs.  If you'd like to use this library, please send
# mail to google-ctemplate@googlegroups.com!
add_library(ctemplate_testing STATIC 
	template_test_util.h
	template_test_util.cc
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
	template_test_util.h
	template_test_util.cc
)
target_link_libraries(ctemplate_testing_nothreads ctemplate_nothreads)
set_target_properties(ctemplate_testing_nothreads 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS} -DNO_THREADS"
)

######## Compile Tests #######
add_executable(compile_test 
	config_for_unittests.h
	compile_test.cc
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
	config_for_unittests.h
	compile_test.cc
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
	config_for_unittests.h
	template_test_util_test.cc
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
	config_for_unittests.h
	template_test_util_test.cc
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
	config_for_unittests.h
	template_dictionary_unittest.cc
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
	config_for_unittests.h
	template_dictionary_unittest.cc
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
	config_for_unittests.h
	template_modifiers_unittest.cc
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
	config_for_unittests.h
	template_modifiers_unittest.cc
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
	config_for_unittests.h
	template_setglobals_unittest.cc
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
	config_for_unittests.h
	template_setglobals_unittest.cc
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
	config_for_unittests.h
	template_cache_test.cc
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
	config_for_unittests.h
	template_cache_test.cc
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
	config_for_unittests.h
	template_unittest.cc
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
	config_for_unittests.h
	template_unittest.cc
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
	config_for_unittests.h
	template_regtest.cc
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
   template_unittest_test_footer.in 
   template_unittest_test_html.in 
   template_unittest_test_invalid1.in 
   template_unittest_test_invalid2.in 
   template_unittest_test_markerdelim.in 
   template_unittest_test_modifiers.in 
   template_unittest_test_nul.in 
   template_unittest_test_selective_css.in 
   template_unittest_test_selective_html.in 
   template_unittest_test_selective_js.in 
   template_unittest_test_simple.in 
   template_unittest_test_valid1.in 
   template_unittest_test_footer_dict01.out 
   template_unittest_test_footer_dict02.out 
   template_unittest_test_html_dict01.out 
   template_unittest_test_html_dict02.out 
   template_unittest_test_markerdelim_dict01.out 
   template_unittest_test_markerdelim_dict02.out 
   template_unittest_test_modifiers_dict01.out 
   template_unittest_test_nul_dict01.out 
   template_unittest_test_selective_css_dict01.out 
   template_unittest_test_selective_css_dict02.out 
   template_unittest_test_selective_html_dict01.out
   template_unittest_test_selective_html_dict02.out 
   template_unittest_test_selective_js_dict01.out 
   template_unittest_test_selective_js_dict02.out 
   template_unittest_test_simple_dict01.out 
   template_unittest_test_simple_dict02.out 
   template_unittest_test_simple_dict03.out
   template_unittest_test_valid1_dict01.out
)

add_executable(template_regtest_nothreads 
	config_for_unittests.h
	template_regtest.cc
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
   template_unittest_test_footer.in 
   template_unittest_test_html.in 
   template_unittest_test_invalid1.in 
   template_unittest_test_invalid2.in 
   template_unittest_test_markerdelim.in 
   template_unittest_test_modifiers.in 
   template_unittest_test_nul.in 
   template_unittest_test_selective_css.in 
   template_unittest_test_selective_html.in 
   template_unittest_test_selective_js.in 
   template_unittest_test_simple.in 
   template_unittest_test_valid1.in 
   template_unittest_test_footer_dict01.out 
   template_unittest_test_footer_dict02.out 
   template_unittest_test_html_dict01.out 
   template_unittest_test_html_dict02.out 
   template_unittest_test_markerdelim_dict01.out 
   template_unittest_test_markerdelim_dict02.out 
   template_unittest_test_modifiers_dict01.out 
   template_unittest_test_nul_dict01.out 
   template_unittest_test_selective_css_dict01.out 
   template_unittest_test_selective_css_dict02.out 
   template_unittest_test_selective_html_dict01.out
   template_unittest_test_selective_html_dict02.out 
   template_unittest_test_selective_js_dict01.out 
   template_unittest_test_selective_js_dict02.out 
   template_unittest_test_simple_dict01.out 
   template_unittest_test_simple_dict02.out 
   template_unittest_test_simple_dict03.out
   template_unittest_test_valid1_dict01.out
)

########### HTMLPARSER C++ TESTS ##############
add_executable(htmlparser_test 
	config_for_unittests.h
	htmlparser_cpp_test.cc
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
   htmlparser_testdata/cdata.html 
   htmlparser_testdata/comments.html 
   htmlparser_testdata/context.html 
   htmlparser_testdata/google.html 
   htmlparser_testdata/javascript_attribute.html 
   htmlparser_testdata/javascript_block.html 
   htmlparser_testdata/javascript_regexp.html 
   htmlparser_testdata/position.html 
   htmlparser_testdata/reset.html 
   htmlparser_testdata/simple.html 
   htmlparser_testdata/tags.html
)

add_executable(htmlparser_test_nothreads 
	config_for_unittests.h
	htmlparser_cpp_test.cc
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
   htmlparser_testdata/cdata.html 
   htmlparser_testdata/comments.html 
   htmlparser_testdata/context.html 
   htmlparser_testdata/google.html 
   htmlparser_testdata/javascript_attribute.html 
   htmlparser_testdata/javascript_block.html 
   htmlparser_testdata/javascript_regexp.html 
   htmlparser_testdata/position.html 
   htmlparser_testdata/reset.html 
   htmlparser_testdata/simple.html 
   htmlparser_testdata/tags.html
)

########### HTMLPARSER C TESTS ##############
# We want to compile statemachine.cc as a c file as well as a c++ file
configure_file(../htmlparser/statemachine.cc statemachine.c COPYONLY)
add_executable(statemachine_test 
	statemachine_test.c
	${CMAKE_CURRENT_BINARY_DIR}/statemachine.c
)
set_target_properties(statemachine_test 
	PROPERTIES
	VERSION ${CTEMPLATE_VERSION}
	SOVERSION ${CTEMPLATE_SOVERSION}
	LINK_FLAGS "${COMMON_LINKER_FLAGS} ${TESTING_LINKER_FLAGS}"
	COMPILE_FLAGS "${COMMON_CXX_FLAGS} ${BASE_COMPILER_FLAGS}"
)
add_test( statemachine_test_1 statemachine_test)
