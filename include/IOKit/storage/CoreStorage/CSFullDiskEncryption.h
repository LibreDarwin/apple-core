/*
 * <IOKit/storage/CoreStorage/CSFullDiskEncryption.h> -- what kext_tools'
 * bootcaches.c takes from libcsfde.
 *
 * Apple publish no copy of this header.  Read from macOS 26.5.2 (25F84):
 *
 *  - CSFDEInitPropertyCache() in libcsfde (dyld shared cache) keeps its
 *    three arguments, strlcpy()s the second into a 0x400-byte path buffer
 *    and appends "/System/Library/Extensions" to it; bootcaches.c passes
 *    the encryption context, that parent path and the wipe-key UUID
 *    string, and tests the result against false.
 *  - bootcaches.c joins the two names below with "/" and strstr()s paths
 *    for the result; stock /usr/sbin/kcditto carries it whole, as
 *    "/System/Library/Caches/com.apple.corestorage/EncryptedRoot.plist.wipekey".
 *
 * CSFDEWritePropertyCacheToFD() is declared by bootcaches.c itself, weak.
 * Only what the tree uses is declared.
 */
#ifndef _CORESTORAGE_CSFULLDISKENCRYPTION_H_
#define _CORESTORAGE_CSFULLDISKENCRYPTION_H_

#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>

#define kCSFDEPropertyCacheDir		"/System/Library/Caches/com.apple.corestorage"
#define kCSFDEPropertyCacheFileEncrypted "EncryptedRoot.plist.wipekey"

CF_EXTERN_C_BEGIN

extern bool CSFDEInitPropertyCache(CFDictionaryRef context,
    const char *path, CFStringRef wipeKeyUUID) __attribute__((weak_import));

CF_EXTERN_C_END

#endif /* _CORESTORAGE_CSFULLDISKENCRYPTION_H_ */
