/*
 * <EFILogin/EFILogin.h> -- what kext_tools' bootcaches.c takes from the
 * EFILogin framework.
 *
 * Apple publish no copy of this header.  bootcaches.c declares
 * EFILoginCopyInterfaceGraphics() itself, weak; it reads each returned
 * resource dictionary with kEFILoginDataKey and kEFILoginFileNameKey,
 * which the SDK's EFILogin.tbd exports as data symbols and stock
 * /usr/sbin/kextcache and kcditto (macOS 26.5.2, 25F84) import as such.
 * Only what the tree uses is declared.
 */
#ifndef _EFILOGIN_EFILOGIN_H_
#define _EFILOGIN_EFILOGIN_H_

#include <CoreFoundation/CoreFoundation.h>

CF_EXTERN_C_BEGIN

extern const CFStringRef kEFILoginDataKey;
extern const CFStringRef kEFILoginFileNameKey;

CF_EXTERN_C_END

#endif /* _EFILOGIN_EFILOGIN_H_ */
