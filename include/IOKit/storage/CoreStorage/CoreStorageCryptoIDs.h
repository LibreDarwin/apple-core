/*
 * <IOKit/storage/CoreStorage/CoreStorageCryptoIDs.h> -- the encryption
 * context keys kext_tools' bootcaches.c reads.
 *
 * Apple publish no copy of this header.  Both are used with CFSTR(), and
 * both are strings in stock /usr/sbin/kcditto (macOS 26.5.2, 25F84), which
 * compiles the same file.  Only what the tree uses is declared.
 */
#ifndef _CORESTORAGE_CORESTORAGECRYPTOIDS_H_
#define _CORESTORAGE_CORESTORAGECRYPTOIDS_H_

#define kCSFDECryptoUsersID		"CryptoUsers"
#define kCSFDELastUpdateTimeID		"LastUpdateTime"

#endif /* _CORESTORAGE_CORESTORAGECRYPTOIDS_H_ */
