/*
 * <fakelink.h> -- what autofs takes from libfakelink.
 *
 * Apple publish no copy of this header.  Read from macOS 26.5.2 (25F84):
 * fakelink_get_property() in libfakelink (dyld shared cache) indexes a
 * table of strings with its first argument and tail-calls
 * snprintf(buf, 0x400, ..., entry) with its second; stock /usr/sbin/automount
 * asks for property 1, the data volume's mount point, into a PATH_MAX
 * buffer, as automountlib/auto_subr.c does.  The SDK's libfakelink.tbd
 * exports it.  Only what the tree uses is declared.
 */
#ifndef _FAKELINK_H_
#define _FAKELINK_H_

#include <sys/cdefs.h>

#define FAKELINK_PROPERTY_DATA_VOLUME_MOUNT_POINT	1

__BEGIN_DECLS

/* buf must hold at least 0x400 (MAXPATHLEN) bytes. */
int fakelink_get_property(int property, char *buf);

__END_DECLS

#endif /* _FAKELINK_H_ */
