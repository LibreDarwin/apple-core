#ifndef _APFS_FSCTL_H_
#define _APFS_FSCTL_H_

#include <sys/ioccom.h>
#include <sys/param.h>	/* MAXPATHLEN */
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

/*
 * For libbless.  Recovered from stock /usr/sbin/bless (macOS 26.5.2,
 * 25F84), which is built from the same libbless sources:
 *
 *  - BLGetAPFSBlessData() passes 0xc0104a0b, _IOWR('J', 11) of the two
 *    64-bit words it reads, and zeroes both on ENOENT;
 *    BLSetAPFSBlessData() passes 0xc0104a0c for the same two words.
 *  - Every snapshot lookup passes 0xc1204a43, _IOWR('J', 67) of a 0x120-
 *    byte structure.  BLGetAPFSSnapshotData() stores the lookup type as a
 *    64-bit word at 0x0 -- 2 after uuid_parse() into 0x8, 3 after
 *    strlcpy() of up to 0xff bytes into 0x20 -- and
 *    BLGetAPFSSnapshotBlessData(), which asks for SNAP_LOOKUP_ROOT, stores
 *    nothing over the zeroed structure, then tests the 64-bit word at 0x18
 *    before uuid_unparse()ing 0x8.
 */
#define APFSIOC_GET_BOOTINFO	_IOWR('J', 11, uint64_t[2])
#define APFSIOC_SET_BOOTINFO	_IOWR('J', 12, uint64_t[2])

#define SNAP_LOOKUP_ROOT	0
#define SNAP_LOOKUP_BY_UUID	2
#define SNAP_LOOKUP_BY_NAME	3

typedef struct {
	uint64_t	type;		/* SNAP_LOOKUP_* */
	unsigned char	snap_uuid[16];	/* uuid_t */
	uint64_t	snap_xid;
	char		snap_name[255];
} apfs_snap_name_lookup_t;

#define APFSIOC_SNAP_LOOKUP	_IOWR('J', 67, apfs_snap_name_lookup_t)

_Static_assert(sizeof(apfs_snap_name_lookup_t) == 0x120,
    "apfs_snap_name_lookup_t is 0x120 bytes, as APFSIOC_SNAP_LOOKUP encodes");

/*
 * The object-ID bit marking the snapshot a volume is rooted to.  libbless'
 * snapshot walk getattrlistbulk()s with FSOPT_LIST_SNAPSHOT and skips
 * entries without it; stock /usr/sbin/bless tests the returned attributes
 * for bit 0 (ATTR_CMN_NAME) and bit 5 (ATTR_CMN_OBJID), then bit 63 of the
 * 64-bit object ID, before strlcpy()ing the name.
 */
#define SNAPSHOT_MARKED_AS_ROOT_TO_BIT	(1ULL << 63)

#endif
