/* Namespace for Google classes */
#cmakedefine GOOGLE_NAMESPACE @GOOGLE_NAMESPACE@

/* the location of <unordered_map> or <hash_map> */
#cmakedefine HASH_MAP_H @HASH_MAP_H@

/* the namespace of hash_map/hash_set */
#cmakedefine HASH_NAMESPACE @HASH_NAMESPACE@

/* the location of <unordered_set> or <hash_set> */
#cmakedefine HASH_SET_H @HASH_SET_H@

/* Define to 1 if you have the <byteswap.h> header file. */
#cmakedefine HAVE_BYTESWAP_H

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_DIRENT_H

/* Define to 1 if you have the <dlfcn.h> header file. */
#cmakedefine HAVE_DLFCN_H

/* Define to 1 if you have the <endian.h> header file. */
#cmakedefine HAVE_ENDIAN_H

/* Define to 1 if you have the `getopt' function. */
#cmakedefine HAVE_GETOPT

/* Define to 1 if you have the <getopt.h> header file. */
#cmakedefine HAVE_GETOPT_H

/* Define to 1 if you have the `getopt_long' function. */
#cmakedefine HAVE_GETOPT_LONG

/* define if the compiler has hash_map */
#cmakedefine HAVE_HASH_MAP

/* define if the compiler has hash_set */
#cmakedefine HAVE_HASH_SET

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H

/* Define to 1 if you have the <libkern/OSByteOrder.h> header file. */
#cmakedefine HAVE_LIBKERN_OSBYTEORDER_H

/* Define to 1 if you have the <machine/endian.h> header file. */
#cmakedefine HAVE_MACHINE_ENDIAN_H

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H

/* define if the compiler implements namespaces */
#cmakedefine HAVE_NAMESPACES

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
#cmakedefine HAVE_NDIR_H

/* Define if you have POSIX threads libraries and header files. */
#cmakedefine HAVE_PTHREAD

/* define if the compiler implements pthread_rwlock_* */
#cmakedefine HAVE_RWLOCK

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H

/* Define to 1 if you have the <sys/byteorder.h> header file. */
#cmakedefine HAVE_SYS_BYTEORDER_H

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_SYS_DIR_H

/* Define to 1 if you have the <sys/endian.h> header file. */
#cmakedefine HAVE_SYS_ENDIAN_H

/* Define to 1 if you have the <sys/isa_defs.h> header file. */
#cmakedefine HAVE_SYS_ISA_DEFS_H

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
   */
#cmakedefine HAVE_SYS_NDIR_H

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H

/* Define to 1 if the system has the type `uint32_t'. */
#cmakedefine HAVE_UINT32_T

/* Define to 1 if the system has the type `uint64_t'. */
#cmakedefine HAVE_UINT64_T

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H

/* define if the compiler supports unordered_{map,set} */
#cmakedefine HAVE_UNORDERED_MAP

/* Define to 1 if you have the <utime.h> header file. */
#cmakedefine HAVE_UTIME_H

/* Define to 1 if the system has the type `u_int32_t'. */
#cmakedefine HAVE_U_INT32_T

/* Define to 1 if the system has the type `uint32_t'. */
#cmakedefine HAVE_UINT32_T

/* Define to 1 if the system has the type `u_int64_t'. */
#cmakedefine HAVE_U_INT64_T

/* Define to 1 if the system has the type `uint64_t'. */
#cmakedefine HAVE_UINT64_T

/* define if your compiler has __attribute__ */
#cmakedefine HAVE___ATTRIBUTE__

/* Define to 1 if the system has the type `__int32'. */
#cmakedefine HAVE___INT32

/* Define to 1 if the system has the type `__int64'. */
#cmakedefine HAVE___INT64

/* The namespace to put the htmlparser code. */
#cmakedefine HTMLPARSER_NAMESPACE

/* define if first argument to InterlockedExchange is just LONG */
#cmakedefine INTERLOCKED_EXCHANGE_NONVOLATILE

/* printf format code for printing a size_t and ssize_t */
#cmakedefine PRIdS "@PRIdS@"

/* printf format code for printing a size_t and ssize_t */
#cmakedefine PRIuS "@PRIuS@"

/* printf format code for printing a size_t and ssize_t */
#cmakedefine PRIxS "@PRIxS@"

/* Define to necessary symbol if this constant uses a non-standard name on
   your system. */
#cmakedefine PTHREAD_CREATE_JOINABLE @PTHREAD_CREATE_JOINABLE@

/* Define to 1 if you have the ANSI C header files. */
#cmakedefine STDC_HEADERS

/* the namespace where STL code like vector<> is defined */
#cmakedefine STL_NAMESPACE @STL_NAMESPACE@

/* Version number of package */
#cmakedefine VERSION "@VERSION@"

/* Version number of package */
#cmakedefine PACKAGE_STRING "@PACKAGE_STRING@"

/* Stops putting the code inside the Google namespace */
#cmakedefine _END_GOOGLE_NAMESPACE_ @_END_GOOGLE_NAMESPACE_@

/* Puts following code inside the Google namespace */
#cmakedefine _START_GOOGLE_NAMESPACE_ @_START_GOOGLE_NAMESPACE_@


#if defined(_MSC_VER) || defined( __MINGW32__) || defined(__MINGW64__)
#ifndef CTEMPLATE_DLL_DECL
# define CTEMPLATE_DLL_DECL  __declspec(dllexport)
# define CTEMPLATE_DLL_DECL_FOR_UNITTESTS  __declspec(dllimport)
#endif
#include "windows/port.h"
#endif

