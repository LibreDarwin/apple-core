/*
 * <IOKit/storage/CoreStorage/CoreStorageUserLib.h> -- what kext_tools'
 * bootcaches.c takes from libCoreStorage.
 *
 * Apple publish no copy of this header.  bootcaches.c declares
 * CoreStorageCopyFamilyProperties() and CoreStorageCopyPVWipeKeyUUID()
 * itself, weak.  Read from macOS 26.5.2 (25F84):
 *
 *  - CoreStorageCopyFamilyProperties() in libCoreStorage (dyld shared
 *    cache) hands its argument straight to CFStringGetCString(), so a
 *    family reference is a CFString -- bootcaches.c passes the family UUID
 *    string;
 *  - the two keys, used with CFSTR(), are strings in stock
 *    /usr/sbin/kcditto: "com.apple.corestorage.lvf.encryption.context"
 *    and "CoreStorage LVF UUID".
 *
 * Only what the tree uses is declared.
 */
#ifndef _CORESTORAGE_CORESTORAGEUSERLIB_H_
#define _CORESTORAGE_CORESTORAGEUSERLIB_H_

#include <CoreFoundation/CoreFoundation.h>

typedef CFStringRef CoreStorageFamilyRef;

#define kCoreStorageFamilyEncryptionContextKey \
	"com.apple.corestorage.lvf.encryption.context"
#define kCoreStorageLVFUUIDKey		"CoreStorage LVF UUID"

#endif /* _CORESTORAGE_CORESTORAGEUSERLIB_H_ */
