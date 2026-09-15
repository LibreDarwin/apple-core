/*-
 * Public Domain dedication for darwintools.
 *
 * <os/base_private.h> shim: provides the OS_* annotation macros that
 * Libc's <os/assumes.h> expects.  These mirror the canonical
 * definitions from libdispatch's os/base_private.h.
 */

#ifndef _OS_BASE_PRIVATE_H_
#define _OS_BASE_PRIVATE_H_

#include <sys/cdefs.h>

/* As the SDK's <os/base.h> spells it: without the extern, <os/log.h>'s
 * OS_EXPORT struct os_log_s _os_log_default becomes a tentative definition. */
#ifndef OS_EXPORT
#if defined(__cplusplus)
#define OS_EXPORT extern "C" __attribute__((__visibility__("default")))
#else
#define OS_EXPORT extern __attribute__((__visibility__("default")))
#endif
#endif

#define OS_WEAK			__attribute__((weak_import))
#define OS_NONSTRING		__attribute__((nonstring))
#define OS_COLD			__attribute__((cold))
#define OS_NOTHROW		__attribute__((nothrow))
#define OS_NONNULL1		__attribute__((nonnull(1)))
#define OS_NONNULL2		__attribute__((nonnull(2)))
#define OS_NONNULL3		__attribute__((nonnull(3)))
#define OS_NONNULL4		__attribute__((nonnull(4)))
#define OS_NONNULL5		__attribute__((nonnull(5)))
#define OS_NONNULL6		__attribute__((nonnull(6)))
#define OS_NONNULL7		__attribute__((nonnull(7)))
#define OS_NONNULL8		__attribute__((nonnull(8)))
#define OS_NONNULL9		__attribute__((nonnull(9)))
#define OS_NONNULL10		__attribute__((nonnull(10)))
#define OS_NONNULL11		__attribute__((nonnull(11)))
#define OS_NONNULL12		__attribute__((nonnull(12)))
#define OS_NONNULL13		__attribute__((nonnull(13)))
#define OS_NONNULL14		__attribute__((nonnull(14)))
#define OS_NONNULL_ALL		__attribute__((nonnull))
#define OS_NOT_TAIL_CALLED	__attribute__((not_tail_called))
#define OS_WARN_RESULT		__attribute__((warn_unused_result))
#define OS_ALWAYS_INLINE	inline __attribute__((always_inline))
#define OS_NOINLINE		__attribute__((noinline))
#define OS_USED			__attribute__((used))
#define OS_UNUSED		__attribute__((unused))
#define OS_TRANSPARENT_UNION	__attribute__((transparent_union))

#define __OS_CONCAT(x, y)	x ## y
#define OS_CONCAT(x, y)		__OS_CONCAT(x, y)

#if defined(__has_feature)
#if __has_feature(pointer_authentication)
#define OS_ASSUME_PTR_ABI_SINGLE_BEGIN \
	_Pragma("clang assume_nonnull nullability on") \
	_Pragma("clang ptrcheck_abi_mode single")
#define OS_ASSUME_PTR_ABI_SINGLE_END \
	_Pragma("clang ptrcheck_abi_mode off") \
	_Pragma("clang assume_nonnull nullability off")
#endif
#endif
#ifndef OS_ASSUME_PTR_ABI_SINGLE_BEGIN
#define OS_ASSUME_PTR_ABI_SINGLE_BEGIN
#define OS_ASSUME_PTR_ABI_SINGLE_END
#endif

/* The compiler-only variants of the C11 _Static_assert machinery. */
#define __OS_COMPILETIME_ASSERT__(e) __compiletime_assert(e)
#define __OS_STRINGIFY(s)	#s
#define OS_STRINGIFY(s)		__OS_STRINGIFY(s)

#define __OS_GNUC_VERSION_GE(major, minor, patch) \
	(__GNUC__ > (major) || (__GNUC__ == (major) && \
	(__GNUC_MINOR__ > (minor) || (__GNUC_MINOR__ == (minor) && \
	__GNUC_PATCHLEVEL__ >= (patch)))))

#ifndef OS_FALLTHROUGH
#if __has_attribute(fallthrough)
#define OS_FALLTHROUGH		__attribute__((fallthrough))
#else
#define OS_FALLTHROUGH
#endif
#endif

#ifndef OS_EXPECT
#define OS_EXPECT(e, v)		__builtin_expect((e), (v))
#endif
#define OS_LIKELY(x)		OS_EXPECT(!!(x), 1)
#define OS_UNLIKELY(x)		OS_EXPECT(!!(x), 0)

#define OS_CSTR(x)		((const char * _Nonnull)(x))

#endif /* !_OS_BASE_PRIVATE_H_ */
