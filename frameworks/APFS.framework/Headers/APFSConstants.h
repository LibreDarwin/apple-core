#ifndef _APFSCONSTANTS_H_
#define _APFSCONSTANTS_H_

#import <CoreFoundation/CoreFoundation.h>

#define apple_apfs 0x1200

#define APFS_BUNDLE_ID "com.apple.filesystems.apfs"
#define APFS_CONTAINER_OBJECT "AppleAPFSContainer"
#define APFS_VOLUME_OBJECT "AppleAPFSVolume"
/* The IOKit class libbless checks a container's media against; stock
 * /usr/sbin/bless carries it beside AppleAPFSContainer and AppleAPFSVolume. */
#define APFS_MEDIA_OBJECT "AppleAPFSMedia"

#define APFS_VOL_ROLE_NONE		0x0000
#define APFS_VOL_ROLE_SYSTEM		0x0001
#define APFS_VOL_ROLE_USER		0x0002
#define APFS_VOL_ROLE_RECOVERY		0x0004
#define APFS_VOL_ROLE_VM		0x0008
#define APFS_VOL_ROLE_PREBOOT		0x0010
#define APFS_VOL_ROLE_INSTALLER		0x0020
#define APFS_VOL_ROLE_DATA		0x0040
#define APFS_VOL_ROLE_BASEBAND		0x0080
#define APFS_VOL_ROLE_RESERVED_200	0x0200

/*
 * The enumerated roles past the single-bit ones, for libbless.  Read from
 * stock /usr/sbin/bless (macOS 26.5.2, 25F84): its role-name-to-role
 * function compares against the role names in libbless's order and
 * returns 0x0, 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80 for the nine
 * above, then these, INTERNAL landing on RESERVED_200's value.
 */
#define APFS_VOL_ROLE_XART		0x0100
#define APFS_VOL_ROLE_INTERNAL		0x0200
#define APFS_VOL_ROLE_BACKUP		0x0180
#define APFS_VOL_ROLE_UPDATE		0x00c0
#define APFS_VOL_ROLE_HARDWARE		0x0140
#define APFS_VOL_ROLE_SIDECAR		0x01c0
#define APFS_VOL_ROLE_ENTERPRISE	0x0240
#define APFS_VOL_ROLE_IDIAGS		0x0280

#define APFS_VOL_ROLES_VALID_MASK	(APFS_VOL_ROLE_SYSTEM \
					| APFS_VOL_ROLE_USER \
					| APFS_VOL_ROLE_RECOVERY \
					| APFS_VOL_ROLE_VM \
					| APFS_VOL_ROLE_PREBOOT \
					| APFS_VOL_ROLE_INSTALLER \
					| APFS_VOL_ROLE_DATA \
					| APFS_VOL_ROLE_BASEBAND \
					| APFS_VOL_ROLE_RESERVED_200)

#define EDT_OS_ENV_MAIN 1
#define EDT_OS_ENV_OTHER 2
#define EDT_OS_ENV_DIAGS 3

#define EDTVolumeFSType			"apfs"
#define EDTVolumePropertySize		(2 << 4)
#define EDTVolumePropertyMaxSize	(2 << 7) // Guessed

#define kAPFSStatusKey "Status"
#define kAPFSRoleKey "Role"
#define kAPFSVolumeRoleSystem "System"
/*
 * The rest of the role names, for libbless.  Read from stock
 * /usr/sbin/bless (macOS 26.5.2, 25F84), whose role-name-to-role function
 * CFEqual()s against these CFStrings in libbless's order -- "System" among
 * them, as above -- before returning each APFS_VOL_ROLE_* value.
 */
#define kAPFSVolumeRoleNone		"none"
#define kAPFSVolumeRoleUser		"User"
#define kAPFSVolumeRoleRecovery		"Recovery"
#define kAPFSVolumeRoleVM		"VM"
#define kAPFSVolumeRolePreBoot		"Preboot"
#define kAPFSVolumeRoleInstaller	"Installer"
#define kAPFSVolumeRoleData		"Data"
#define kAPFSVolumeRoleBaseband		"Baseband data"
#define kAPFSVolumeRoleXART		"xART"
#define kAPFSVolumeRoleInternal		"Internal"
#define kAPFSVolumeRoleBackup		"Backup"
#define kAPFSVolumeRoleUpdate		"Update"
#define kAPFSVolumeRoleHardware		"Hardware"
#define kAPFSVolumeRoleSideCar		"SideCar"
#define kAPFSVolumeRoleEnterprise	"Enterprise data"
#define kAPFSVolumeRoleIDiags		"iDiags"
#define kAPFSVolGroupUUIDKey "VolGroupUUID"

#define kEDTFilesystemEntry "IODeviceTree:/filesystems/fstab"
#define kEDTOSEnvironment CFSTR("os_env_type")

enum {
    kAPFSXSubType    = 0,    /* APFS Case-sensitive */
    kAPFSSubType     = 1     /* APFS Case-insensitive */
};

/*
kAPFSContainerBlocksizeKey
kAPFSContainerExtentAddressKey
kAPFSContainerExtentLengthKey
kAPFSContainerExtentsListKey
kAPFSContainerFSTypeKey
kAPFSContainerSizeKey
kAPFSContainerTidemarkKey
kAPFSStreamCreateEmbedCRC
kAPFSStreamCreateReadAlignment
kAPFSVolumeCaseSensitiveKey
kAPFSVolumeEffaceableKey
kAPFSVolumeEncryptedACMKey
kAPFSVolumeEncryptedKey
kAPFSVolumeFSIndexKey
kAPFSVolumeGroupSiblingFSIndexKey
kAPFSVolumeNameKey
kAPFSVolumeNoAutomountAtCreateKey
kAPFSVolumeQuotaSizeKey
kAPFSVolumeReserveSizeKey
kAPFSVolumeRoleKey
*/

#endif
