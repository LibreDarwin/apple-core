/*
 * <SkyLight/SLSDisplayManager.h> -- the one SkyLight display call pmset
 * makes, for `pmset displaysleepnow`.
 *
 * Apple publish no copy of this header.  Stock /usr/bin/pmset (macOS
 * 26.5.2, 25F84) imports SLSDisplayManagerRequestDisplaysIdle from
 * SkyLight, which the SDK's SkyLight.tbd exports; pmset.m calls it with no
 * arguments and compares the result with kCGErrorSuccess.  Only what the
 * tree uses is declared.
 */
#ifndef _SKYLIGHT_SLSDISPLAYMANAGER_H_
#define _SKYLIGHT_SLSDISPLAYMANAGER_H_

#include <CoreGraphics/CGError.h>

CF_EXTERN_C_BEGIN

extern CGError SLSDisplayManagerRequestDisplaysIdle(void);

CF_EXTERN_C_END

#endif /* _SKYLIGHT_SLSDISPLAYMANAGER_H_ */
