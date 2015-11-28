   check_cxx_source_compiles("#include <stdlib.h>
       static void foo(void) __attribute__ ((unused));
       void foo(void) { exit(1); }"
                                 HAVE___ATTRIBUTE__)

if(HAVE___ATTRIBUTE__)
	set(ac_google_attribute 1)
else()
	set(ac_google_attribute 0)
endif()