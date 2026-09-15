/*
 * <MultiverseSupport/kext_audit_plugin_common.h> -- the protocol between
 * kextload/kextutil and the KextAudit kext's user client.
 *
 * Apple publish no copy of this header.  Names are the ones kext_tools'
 * own kextaudit.c and KextAudit/ sources use; the values are read from
 * stock /usr/bin/kextutil (macOS 26.5.2, 25F84), which compiles the same
 * kextaudit.c:
 *
 *  - KextAuditMakeKALNFromInfo() stores the load type as a 16-bit word at
 *    offset 0 -- 6 for a 40-character CDHash, 7 for a 64-character one --
 *    copies 32 bytes of raw CDHash to 0x2, strncpy()s 11 bytes of team ID
 *    to 0x22, copies the 32-byte bundle ID hash to 0x2d and strncpy()s 21
 *    bytes of version to 0x4d, NUL-terminating 0x2c and 0x61.
 *  - KextAuditNotifyBridgeWithReplySync() calls selector 0 with a 0x64-byte
 *    input structure and a one-byte output whose status it preset to 1.
 *  - After the call, status 2 continues and status 3 logs "didn't find a
 *    bridge" with audit=F, as kextaudit.c does for kKALNStatusNoBridge.
 *
 * KextAuditUserClient.cpp's dispatch table lists notifyLoad then test, so
 * kKextAuditMethodTest (used only under DEBUG) is 1.  The two bytes past
 * the version are not referenced by kextaudit.c; they are what makes the
 * structure the 0x64 bytes stock kextutil sends.
 */
#ifndef _MULTIVERSESUPPORT_KEXT_AUDIT_PLUGIN_COMMON_H_
#define _MULTIVERSESUPPORT_KEXT_AUDIT_PLUGIN_COMMON_H_

#include <stdint.h>

enum KextAuditMethod {
	kKextAuditMethodNotifyLoad	= 0,
	kKextAuditMethodTest		= 1,
	kKextAuditMethodCount
};

enum KextAuditLoadType {
	kKALTKextCDHashSha1		= 6,
	kKALTKextCDHashSha256		= 7,
};

enum KextAuditLoadStatus {
	kKALNStatusLoad			= 1,
	kKALNStatusBridgeAck		= 2,
	kKALNStatusNoBridge		= 3,
};

#define kKALNKCDHashSize	32
#define kKALNKTeamIDSize	11
#define kKALNKBundleHashSize	32
#define kKALNKKextVersionSize	21

struct KextAuditLoadNotificationKext {
	uint16_t	loadType;
	uint8_t		cdHash[kKALNKCDHashSize];
	char		teamID[kKALNKTeamIDSize];
	uint8_t		bundleHash[kKALNKBundleHashSize];
	char		kextVersion[kKALNKKextVersionSize];
	uint8_t		reserved[2];
} __attribute__((packed));

#define kKALNStructSize		sizeof(struct KextAuditLoadNotificationKext)

struct KextAuditBridgeResponse {
	uint8_t		status;
} __attribute__((packed));

_Static_assert(sizeof(struct KextAuditLoadNotificationKext) == 0x64,
    "KextAuditLoadNotificationKext is 0x64 bytes on the wire");
_Static_assert(sizeof(struct KextAuditBridgeResponse) == 1,
    "KextAuditBridgeResponse is one byte on the wire");

#endif /* _MULTIVERSESUPPORT_KEXT_AUDIT_PLUGIN_COMMON_H_ */
