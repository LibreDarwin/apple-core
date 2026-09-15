/*
 * Copyright (c) 2018 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

/*
 * apple-core: the __os_free and __os_close attributes from Libc-1752.120.2's
 * libdarwin/h/cleanup.h, verbatim.  The rest of that header needs
 * libdarwin's private <os/api.h> and <mach/mach_right_private.h>, and
 * nothing in the tree uses it; add more of it here when something does.
 */
#ifndef __DARWIN_CLEANUP_H
#define __DARWIN_CLEANUP_H

#include <os/base.h>
#include <os/assumes.h>
#include <sys/cdefs.h>
#include <stdlib.h>
#include <unistd.h>

__BEGIN_DECLS;

#if __has_attribute(cleanup)
/*!
 * @define __os_free
 * An attribute that may be applied to a variable's type. This attribute causes
 * the variable to be passed to free(3) when it goes out of scope. Applying this
 * attribute to variables that do not reference heap allocations will result in
 * undefined behavior.
 */
#define __os_free __attribute__((cleanup(__os_cleanup_free)))
static inline void
__os_cleanup_free(void *__p)
{
	void **tp = (void **)__p;
	void *p = *tp;
	free(p);
}

/*!
 * @define __os_close
 * An attribute that may be applied to a variable's type. This attribute causes
 * the variable to be passed to close(2) when it goes out of scope. Applying
 * this attribute to variables that do not reference a valid file descriptor
 * will result in undefined behavior. If the variable's value is -1 upon going
 * out-of-scope, no cleanup is performed.
 */
#define __os_close __attribute__((cleanup(__os_cleanup_close)))
static inline void
__os_cleanup_close(int *__fd)
{
	int fd = *__fd;
	if (fd == -1) {
		return;
	}
	posix_assert_zero(close(fd));
}
#endif /* __has_attribute(cleanup) */

__END_DECLS;

#endif /* __DARWIN_CLEANUP_H */
