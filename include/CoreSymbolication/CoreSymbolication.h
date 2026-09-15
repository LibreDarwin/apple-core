/*-
 * Public Domain dedication for darwintools.
 *
 * <CoreSymbolication/CoreSymbolication.h> -- the CoreSymbolication calls
 * system_cmds' zprint and zlog make.  CoreSymbolication is a private
 * framework with no published header; its binary ships with macOS and
 * these entry points are exported.
 *
 * Every CoreSymbolication reference is a two-word value, not a pointer.
 * Read from CoreSymbolication in macOS 26.5.2's (25F84) dyld shared cache:
 * CSIsNull() tests its argument across both x0 and x1, as CSRetain(),
 * CSRegionGetName(), CSSymbolOwnerForeachSegment() and the *AtTime()
 * lookups do before reading anything, so references are passed and
 * returned as a 16-byte struct.  CSRegionGetRange() likewise returns a
 * two-word range in x0 and x1.  CSSymbolOwnerGetCFUUIDBytes() returns a
 * pointer into the owner's storage.  Only what the tree uses is declared.
 */

#ifndef _CORESYMBOLICATION_CORESYMBOLICATION_H_
#define _CORESYMBOLICATION_CORESYMBOLICATION_H_

#include <CoreFoundation/CoreFoundation.h>
#include <mach/mach_types.h>
#include <stdint.h>

__BEGIN_DECLS

typedef struct _CSTypeRef {
	uintptr_t	csCppData;
	uintptr_t	csCppObj;
} CSTypeRef;

typedef CSTypeRef CSSymbolicatorRef;
typedef CSTypeRef CSSymbolOwnerRef;
typedef CSTypeRef CSSymbolRef;
typedef CSTypeRef CSSourceInfoRef;
typedef CSTypeRef CSRegionRef;
typedef CSTypeRef CSSegmentRef;

typedef struct _CSRange {
	uint64_t	location;
	uint64_t	length;
} CSRange;

/* The "now" time constant used by every *AtTime() call. */
#define kCSNow		(~(uint64_t)0)
#define kCSNull		((CSTypeRef){ 0, 0 })

Boolean CSIsNull(CSTypeRef cs);
CSTypeRef CSRetain(CSTypeRef cs);
void CSRelease(CSTypeRef cs);

CSSymbolicatorRef CSSymbolicatorCreateWithMachKernel(void);

CSSymbolOwnerRef CSSymbolicatorGetSymbolOwnerWithAddressAtTime(
	CSSymbolicatorRef	symbolicator,
	mach_vm_address_t	address,
	uint64_t		time);

CSSymbolRef CSSymbolicatorGetSymbolWithAddressAtTime(
	CSSymbolicatorRef	symbolicator,
	mach_vm_address_t	address,
	uint64_t		time);

CSSourceInfoRef CSSymbolicatorGetSourceInfoWithAddressAtTime(
	CSSymbolicatorRef	symbolicator,
	mach_vm_address_t	address,
	uint64_t		time);

const char *CSSymbolGetName(CSSymbolRef symbol);
const char *CSSourceInfoGetPath(CSSourceInfoRef sourceInfo);
size_t	CSSourceInfoGetLineNumber(CSSourceInfoRef sourceInfo);

const char *CSSymbolOwnerGetName(CSSymbolOwnerRef owner);
const char *CSSymbolOwnerGetPath(CSSymbolOwnerRef owner);
const CFUUIDBytes *CSSymbolOwnerGetCFUUIDBytes(CSSymbolOwnerRef owner);
size_t	CSSymbolOwnerForeachSegment(CSSymbolOwnerRef owner,
	void (^block)(CSSegmentRef segment));

const char *CSRegionGetName(CSRegionRef region);
CSRange	CSRegionGetRange(CSRegionRef region);

__END_DECLS

#endif /* !_CORESYMBOLICATION_CORESYMBOLICATION_H_ */
