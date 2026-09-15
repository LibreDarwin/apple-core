/*
 * <MediaKit/GPTTypes.h> -- the GPT partition type kext_tools' update_boot.c
 * checks a CoreStorage data partition against.
 *
 * Apple publish no copy of this header.  update_boot.c compares an IOMedia
 * content key with CFSTR(APPLE_CORESTORAGE_UUID) and logs "must be of type
 * Apple_CoreStorage" otherwise.  Stock /usr/sbin/kextcache (macOS 26.5.2,
 * 25F84) carries six partition-type GUID strings; this is the one whose
 * first eight bytes spell "Storag" in ASCII, as its siblings there spell
 * "Boot" (426F6F74-..., Apple_Boot) and "HFS" (48465300-..., Apple_HFS),
 * all sharing Apple's -11AA-AA11-00306543ECAC tail.  Only what the tree
 * uses is declared.
 */
#ifndef _MEDIAKIT_GPTTYPES_H_
#define _MEDIAKIT_GPTTYPES_H_

#define APPLE_CORESTORAGE_UUID	"53746F72-6167-11AA-AA11-00306543ECAC"

#endif /* _MEDIAKIT_GPTTYPES_H_ */
