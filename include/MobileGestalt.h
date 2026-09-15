/*
 * <MobileGestalt.h> -- what PowerManagement's pmset takes from
 * libMobileGestalt.
 *
 * Apple publish no copy of this header.  Stock /usr/bin/pmset (macOS
 * 26.5.2, 25F84) imports MGGetBoolAnswer, which the SDK's
 * libMobileGestalt.tbd exports, and carries the question string
 * "DeviceSupportsActionAfterPowerConnect" that pmset.m asks it through
 * kMGQDeviceSupportsActionAfterPowerConnect.  Only what the tree uses is
 * declared.
 */
#ifndef _MOBILEGESTALT_H_
#define _MOBILEGESTALT_H_

#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>

CF_EXTERN_C_BEGIN

#define kMGQDeviceSupportsActionAfterPowerConnect \
	CFSTR("DeviceSupportsActionAfterPowerConnect")

extern bool MGGetBoolAnswer(CFStringRef question);

CF_EXTERN_C_END

#endif /* _MOBILEGESTALT_H_ */
