#ifndef _APFS_FSCTL_H_
#define _APFS_FSCTL_H_

#include <sys/ioccom.h>
#include <stdint.h>

struct xdstream_obj_id {
	char *xdi_name;
	int xdi_xdtream_obj_id;
};

#define APFS_NAME_MAX_BYTES (255*3)

typedef struct {
	char synth_link_name[APFS_NAME_MAX_BYTES];
	char synth_target_path[MAXPATHLEN];
} apfs_create_synth_symlink_t;

#define APFSIOC_FIRMLINK_CTL	0xc4084a3c
#define APFSIOC_XDSTREAM_OBJ_ID	0xc0104a35

#define APFS_PURGEABLE_FLAGS_MASK 0xFFFF

#define APFSIOC_GET_PURGEABLE_FILE_FLAGS _IOR('J', 71, uint64_t)

/*
 * Recovered from libremovefile in macOS 26.5.2's dyld shared cache, whose
 * removefile_tree_walker.c calls fsctl(path, APFSIOC_MARK_PURGEABLE,
 * &cp_flags, 0) with cp_flags = APFS_CLEAR_PURGEABLE when
 * REMOVEFILE_CLEAR_PURGEABLE is set: both call sites test bit 9 of the
 * unlink flags -- (1 << 9) in the published removefile.h -- then store 0
 * in the flags word and pass request 0xc0084a44, _IOWR('J', 68, uint64_t).
 */
#define APFS_CLEAR_PURGEABLE		0
#define APFSIOC_MARK_PURGEABLE		_IOWR('J', 68, uint64_t)
#define APFSIOC_CREATE_SYNTHETIC_SYMLINK _IOW('J', 75, apfs_create_synth_symlink_t)
#define APFSIOC_CREATE_HIDDEN_SYNTHETIC_SYMLINK _IOW('J', 78, apfs_create_synth_symlink_t)

#endif
