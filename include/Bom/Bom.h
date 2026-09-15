/*
 * <Bom/Bom.h> -- the BOMCopier half of the Bom framework, which BomCmds'
 * ditto, mkbom and lsbom reach through <Bom/Bom.h>.
 *
 * Apple publish no copy of this header (BomCmds carries its own, older
 * subset beside its sources, without BOMCopierCopy or the copy-operation
 * results).  Names and handler shapes follow kext_tools' kc_staging.m, for
 * which this was first written; the rest is read from stock
 * /usr/sbin/kcditto (macOS 26.5.2, 25F84), which imports these six
 * functions from Bom:
 *
 *  - its file-error handler logs and returns 0, kc_staging.m's
 *    BOMCopierContinue;
 *  - BOMCopierCopy() is called with the copier and two C paths, and its
 *    result is compared against EX_OK.
 *
 * Only what the tree uses is declared.
 */
#ifndef _BOM_BOM_H_
#define _BOM_BOM_H_

#include <sys/cdefs.h>

__BEGIN_DECLS

typedef struct BOMCopier *BOMCopier;

typedef enum {
	BOMCopierContinue	= 0,
} BOMCopierCopyOperation;

typedef void (*BOMCopierFatalErrorHandler)(BOMCopier copier,
    const char *message);
typedef void (*BOMCopierFatalFileErrorHandler)(BOMCopier copier,
    const char *path, int errnum);
typedef BOMCopierCopyOperation (*BOMCopierFileErrorHandler)(BOMCopier copier,
    const char *path, int errnum);

BOMCopier BOMCopierNew(void);
void BOMCopierFree(BOMCopier copier);
int BOMCopierCopy(BOMCopier copier, const char *fromObj, const char *toObj);
void BOMCopierSetFatalErrorHandler(BOMCopier copier,
    BOMCopierFatalErrorHandler handler);
void BOMCopierSetFatalFileErrorHandler(BOMCopier copier,
    BOMCopierFatalFileErrorHandler handler);
void BOMCopierSetFileErrorHandler(BOMCopier copier,
    BOMCopierFileErrorHandler handler);

__END_DECLS

#endif /* _BOM_BOM_H_ */
