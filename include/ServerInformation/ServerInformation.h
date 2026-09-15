/*
 * <ServerInformation/ServerInformation.h> -- what autofs takes from the
 * ServerInformation framework.
 *
 * Apple publish no copy of this header.  Read from macOS 26.5.2 (25F84):
 * SIIsOSXServerVolumeConfigured() in ServerInformation (dyld shared cache)
 * CFStringGetCString()s its one argument when it is not NULL -- a volume
 * path -- and falls back to the boot volume otherwise; stock
 * /usr/libexec/automountd calls it with NULL and keeps the result as its
 * yes/no answer.  The SDK's ServerInformation.tbd exports it.  Only what
 * the tree uses is declared.
 */
#ifndef _SERVERINFORMATION_SERVERINFORMATION_H_
#define _SERVERINFORMATION_SERVERINFORMATION_H_

#include <CoreFoundation/CoreFoundation.h>

CF_EXTERN_C_BEGIN

extern Boolean SIIsOSXServerVolumeConfigured(CFStringRef volumePath);

CF_EXTERN_C_END

#endif /* _SERVERINFORMATION_SERVERINFORMATION_H_ */
