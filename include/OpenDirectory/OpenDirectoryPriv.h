/*
 * Copyright (c) 2005-2008 Apple Inc. All rights reserved.
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
 * darwintools note: Apple's <OpenDirectory/OpenDirectoryPriv.h> is not in
 * the public macOS SDK.  The darwintools consumers (passwd, chpass) also
 * include the public <OpenDirectory/OpenDirectory.h> first, which already
 * declares every symbol they use (ODNodeCreateWithNodeType, ODNodeCopyRecord,
 * ODRecordChangePassword, the kOD* constants, ...) by way of the embedded
 * CFOpenDirectory subframework.  The truly-private CFOpenDirectoryPriv.h /
 * NSOpenDirectoryPriv.h contribute nothing those tools reference, so this
 * shim only needs to satisfy the #include.
 */
#ifndef __OPENDIRECTORYPRIV_H
#define __OPENDIRECTORYPRIV_H

#include <OpenDirectory/OpenDirectory.h>

#endif /* __OPENDIRECTORYPRIV_H */
