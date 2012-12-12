// @@@LICENSE
//
//      Copyright (c) 2009-2012 Hewlett-Packard Development Company, L.P.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// LICENSE@@@

/**
 * This file should be safe to be included multiple times (no include guard)
 * because it is controlled through the NDEBUG preprocessor macro.
 */
#include <assert.h>
#include <compiler/assert_helpers.h>
#include <compiler/throw_attribute.h>
#include <compiler/noreturn_attribute.h>

#cmakedefine HAVE_ASSERT_FAIL 1

#ifndef __STRING
	#define __STRING(expr) #expr
#endif

#ifdef NDEBUG
	#define assert_msg(expr, msg, ...) assert(expr)
#else
	#if !HAVE_ASSERT_FAIL
	#include <stdlib.h>
	#include <stdio.h>

	static void __assert_fail (__const char *__assertion, __const char *__file,
	                           unsigned int __line, __const char *__function)
	                           NOTHROW NORETURN;

	static void __assert_fail (__const char *__assertion, __const char *__file,
	                           unsigned int __line, __const char *__function)
#ifdef __cplusplus
	                           NOTHROW
#endif
	{
		fprintf(stderr, "%s:%u: failed assertion `%s' in %s\n", __file, __line, __assertion, __function);
		abort();
	}
	#endif

	void __assert_fail_msg (__const char *__assertion, __const char *__file,
	                        unsigned int __line, __const char *__function, const char *format, ...)
	                        NOTHROW NORETURN;

	#define assert_msg(expr, format, ...)               \
	  ((expr)                                           \
	   ? __ASSERT_VOID_CAST (0)                         \
	   : __assert_fail_msg (__STRING(expr), __FILE__, __LINE__, __ASSERT_FUNCTION, format, ##__VA_ARGS__))
#endif

