/*
 * <NetFS/NetFSPrivate.h> -- the private NetFS mount-option keys autofs'
 * mount_url uses.
 *
 * Apple publish no copy of this header; the public <NetFS/NetFS.h> has
 * every other key mount_url sets.  mount_url adds kUIOptionKey with value
 * kUIOptionNoUI to its mount options; stock /usr/libexec/mount_url (macOS
 * 26.5.2, 25F84) carries the two strings "UIOption" and "NoUI" beside the
 * public keys ("NoUserPreferences", "AllowSubMounts", "MountFlags").  Only
 * what the tree uses is declared.
 */
#ifndef _NETFS_NETFSPRIVATE_H_
#define _NETFS_NETFSPRIVATE_H_

#include <CoreFoundation/CoreFoundation.h>

#define kUIOptionKey		CFSTR("UIOption")
#define kUIOptionNoUI		CFSTR("NoUI")

/*
 * The session calls mount_url's direct path makes, exported by the SDK's
 * NetFS.tbd.  Read from NetFS in the dyld shared cache and stock mount_url:
 * netfs_CreateSessionRef() keeps its second argument (mount_url passes the
 * address of a void *); netfs_OpenSession() keeps four (mount_url's last is
 * NULL); netfs_CloseSession() takes the session alone; netfs_Mount() keeps
 * five, the last the address of mount_url's CFDictionaryRef mount info.
 * Each result is compared against 0.
 */
CF_EXTERN_C_BEGIN

extern int netfs_CreateSessionRef(CFURLRef url, void **sessionRef);
extern int netfs_OpenSession(CFURLRef url, void *sessionRef,
    CFDictionaryRef openOptions, CFDictionaryRef *sessionInfo);
extern int netfs_CloseSession(void *sessionRef);
extern int netfs_Mount(void *sessionRef, CFURLRef url, CFStringRef mountpath,
    CFDictionaryRef mountOptions, CFDictionaryRef *mountInfo);

CF_EXTERN_C_END

#endif /* _NETFS_NETFSPRIVATE_H_ */
