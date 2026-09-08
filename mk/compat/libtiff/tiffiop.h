/*
 * tiffiop.h -- the three definitions tiffdump.c uses out of libtiff's real
 * private header, copied verbatim from libtiff 4.6.0 libtiff/tiffiop.h
 * (the non-Windows branch).
 *
 * The real tiffiop.h declares `struct tiff' and would tie this build to one
 * libtiff release; tiffdump.c never touches those internals -- it reads the
 * file with open(2)/read(2) and otherwise uses only the public tiffio.h API
 * -- so pulling in just these keeps the vendored code decoupled from
 * whichever libtiff we link against.
 */
#ifndef _DARWINTOOLS_TIFFIOP_H_
#define _DARWINTOOLS_TIFFIOP_H_

#include <sys/types.h>
#include <unistd.h>

/* Safe multiply which returns zero if there is an *unsigned* integer overflow.
 * This macro is not safe for *signed* integer types */
#define TIFFSafeMultiply(t, v, m)                                              \
    ((((t)(m) != (t)0) && (((t)(((v) * (m)) / (m))) == (t)(v)))                \
         ? (t)((v) * (m))                                                      \
         : (t)0)

#define _TIFF_lseek_f(fildes, offset, whence) lseek(fildes, offset, whence)
#define _TIFF_off_t off_t

#endif /* _DARWINTOOLS_TIFFIOP_H_ */
