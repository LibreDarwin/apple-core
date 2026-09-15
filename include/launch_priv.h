/*
 * <launch_priv.h> -- apple-core's stand-in for launchd's private header.
 *
 * kext_tools' driverkit.m is the one user: it submits a dext's job with
 * launch_msg(LAUNCH_KEY_SUBMITJOB), which the public <launch.h> declares,
 * and sets its ProcessType to LAUNCH_KEY_PROCESSTYPE_DRIVER, which only
 * the private header does.  Its value is read from stock /sbin/launchd
 * (macOS 26.5.2, 25F84): among the ProcessType strings that binary
 * carries, "Driver" sits with "Adaptive", "Background", "Interactive" and
 * "Standard", the last three of which <launch.h> publishes under the same
 * LAUNCH_KEY_PROCESSTYPE_ names.  Only what the tree uses is declared.
 */
#ifndef __LAUNCH_PRIVATE_H__
#define __LAUNCH_PRIVATE_H__

#include <launch.h>

#define LAUNCH_KEY_PROCESSTYPE_DRIVER	"Driver"

#endif /* __LAUNCH_PRIVATE_H__ */
