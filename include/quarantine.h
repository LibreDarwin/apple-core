/*
 * quarantine.h -- the file quarantine SPI.
 *
 * Apple's libarchive includes this: archive_mac.h sets
 * HAVE_MAC_QUARANTINE on macOS and pulls it in, and the extract path
 * calls qtn_file_alloc(), qtn_file_init_with_fd(), qtn_file_clone(),
 * qtn_file_apply_to_path() and qtn_file_free() to carry the quarantine
 * attribute from an archive onto what comes out of it.  Apple publish
 * no source for it and no SDK ships the header, so this is
 * reconstructed.
 *
 * The names carry asm labels, and that is the whole point of this
 * file.  libquarantine exports __qtn_file_alloc, not _qtn_file_alloc:
 * the symbols are spelled with a leading underscore underneath, while
 * the API every caller writes has none.  Apple's own libquarantine.tbd
 * shows the same thing, so their header must map the two, and without
 * that mapping nothing linked -- which is how this was found.
 *
 * The list is exactly what libquarantine exports.  Only the calls
 * libarchive makes have signatures written out; the rest are named
 * with their labels so the mapping is complete and correct as far as
 * it goes, and are commented as unreconstructed rather than guessed
 * at.
 *
 * Copyright (c) 2026 Sunneva N. Mariu <sunnevanattsol@gmail.com>
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef __QUARANTINE_H__
#define __QUARANTINE_H__

#include <sys/types.h>
#include <stdint.h>

__BEGIN_DECLS

typedef struct _qtn_file *qtn_file_t;
typedef struct _qtn_proc *qtn_proc_t;

/* Quarantine flags, as stored in the com.apple.quarantine xattr. */
#define QTN_FLAG_DOWNLOAD		0x0001
#define QTN_FLAG_SANDBOX		0x0002
#define QTN_FLAG_HARD			0x0004
#define QTN_FLAG_USER_APPROVED		0x0040
#define QTN_NOT_QUARANTINED		ENOATTR

/*
 * The file interface.  These five are what Apple's libarchive uses,
 * and they are the ones this tree needs to be right.
 */
extern qtn_file_t qtn_file_alloc(void)
    __asm__("__qtn_file_alloc");
extern void qtn_file_free(qtn_file_t qf)
    __asm__("__qtn_file_free");
extern qtn_file_t qtn_file_clone(qtn_file_t qf)
    __asm__("__qtn_file_clone");
extern int qtn_file_init_with_fd(qtn_file_t qf, int fd)
    __asm__("__qtn_file_init_with_fd");
extern int qtn_file_init_with_path(qtn_file_t qf, const char *path)
    __asm__("__qtn_file_init_with_path");
extern int qtn_file_apply_to_fd(qtn_file_t qf, int fd)
    __asm__("__qtn_file_apply_to_fd");
extern int qtn_file_apply_to_path(qtn_file_t qf, const char *path)
    __asm__("__qtn_file_apply_to_path");

extern uint32_t qtn_file_get_flags(qtn_file_t qf)
    __asm__("__qtn_file_get_flags");
extern int qtn_file_set_flags(qtn_file_t qf, uint32_t flags)
    __asm__("__qtn_file_set_flags");

extern const char *qtn_error(int err)
    __asm__("__qtn_error");
/*
 * Not a function: libquarantine exports __qtn_xattr_name from
 * __TEXT,__const as the string itself ("com.apple.quarantine"), and
 * copyfile uses it as XATTR_QUARANTINE_NAME.
 */
extern const char qtn_xattr_name[]
    __asm__("__qtn_xattr_name");

/*
 * The rest of what libquarantine exports.  Nothing in this tree calls
 * them and their signatures are not recoverable from the stub alone,
 * so they are deliberately not declared here rather than declared
 * wrongly -- a caller that needs one should work out its shape and add
 * it, with the label below.
 *
 *	__qtn_file_init			__qtn_file_init_with_data
 *	__qtn_file_init_with_mount_point
 *	__qtn_file_init_with_disk_image_backing_store
 *	__qtn_file_apply_to_mount_point	__qtn_file_to_data
 *	__qtn_file_get_identifier	__qtn_file_set_identifier
 *	__qtn_file_get_metadata		__qtn_file_set_metadata
 *	__qtn_file_get_metadata_size
 *	__qtn_file_get_timestamp	__qtn_file_set_timestamp
 *	__qtn_label_name
 *
 *	__qtn_proc_alloc		__qtn_proc_free
 *	__qtn_proc_clone		__qtn_proc_init
 *	__qtn_proc_init_with_data	__qtn_proc_init_with_self
 *	__qtn_proc_apply_to_pid		__qtn_proc_apply_to_self
 *	__qtn_proc_to_data
 *	__qtn_proc_get_flags		__qtn_proc_set_flags
 *	__qtn_proc_get_identifier	__qtn_proc_set_identifier
 *	__qtn_proc_get_metadata		__qtn_proc_set_metadata
 *	__qtn_proc_get_metadata_size
 *	__qtn_proc_get_path_exclusion_pattern
 *	__qtn_proc_set_path_exclusion_pattern
 *	__qtn_proc_get_tracking_data	__qtn_proc_get_tracking_size
 *	__qtn_proc_set_tracking_data
 */

__END_DECLS


/*
 * Added for copyfile.  The signatures are the ones copyfile.c's own
 * non-macOS stubs give these functions; the two constants are read from
 * libcopyfile in macOS 26.5.2's dyld shared cache:
 *
 *  - QTN_FLAG_DO_NOT_TRANSLOCATE: with COPYFILE_RUN_IN_PLACE (1 << 26) set,
 *    copyfile ORs 0x100 into the result of qtn_file_get_flags() and hands
 *    it to qtn_file_set_flags().
 *  - QTN_SERIALIZED_DATA_MAX: copyfile_pack_quarantine() stores 0x1060,
 *    sizeof its buffer, as the length it passes qtn_file_to_data().
 */
#define QTN_FLAG_DO_NOT_TRANSLOCATE	0x0100
#define QTN_SERIALIZED_DATA_MAX		0x1060

extern int qtn_file_init_with_data(qtn_file_t qf, const void *data, size_t len)
    __asm__("__qtn_file_init_with_data");
extern int qtn_file_to_data(qtn_file_t qf, char *buf, size_t *len)
    __asm__("__qtn_file_to_data");

#endif /* __QUARANTINE_H__ */
