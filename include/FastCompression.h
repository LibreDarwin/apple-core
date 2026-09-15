/*
 * <FastCompression.h> -- apple-core's stand-in for Apple's static
 * FastCompression library, which kext_tools' kernelcache.c uses for
 * prelinked-kernel lzvn.
 *
 * Apple publish neither the header nor libFastCompression.a; stock
 * /usr/sbin/kextcache carries its lzvn coder linked in.  libcompression,
 * which the SDK does publish, has the same coder: asked for algorithm
 * 0x900 (its private LZVN value) it writes a raw lzvn stream with no block
 * header -- a probe compressing 4 KiB of repeated text on macOS 26.5.2
 * returned 54 bytes starting e8 61 62 63 ..., an lzvn literal opcode
 * followed by the literal bytes.  These wrappers give kernelcache.c the
 * three calls it makes over that.  Link with -lcompression.
 *
 * libcompression's three functions are declared here rather than through
 * <compression.h>: kext_tools has a compression.h of its own on the
 * include path, which shadows the SDK's.  The signatures are the SDK
 * header's, with compression_algorithm, an int-sized enum, spelled int.
 */
#ifndef _FASTCOMPRESSION_H_
#define _FASTCOMPRESSION_H_

#include <stddef.h>
#include <stdint.h>

#define APPLECORE_COMPRESSION_LZVN	0x900

extern size_t compression_encode_scratch_buffer_size(int algorithm);
extern size_t compression_encode_buffer(uint8_t *dst_buffer, size_t dst_size,
    const uint8_t *src_buffer, size_t src_size, void *scratch_buffer,
    int algorithm);
extern size_t compression_decode_buffer(uint8_t *dst_buffer, size_t dst_size,
    const uint8_t *src_buffer, size_t src_size, void *scratch_buffer,
    int algorithm);

static inline size_t
lzvn_encode_work_size(void)
{
	return compression_encode_scratch_buffer_size(APPLECORE_COMPRESSION_LZVN);
}

static inline size_t
lzvn_encode(void *dst, size_t dst_size, const void *src, size_t src_size,
    void *work)
{
	return compression_encode_buffer(dst, dst_size, src, src_size, work,
	    APPLECORE_COMPRESSION_LZVN);
}

static inline size_t
lzvn_decode(void *dst, size_t dst_size, const void *src, size_t src_size)
{
	return compression_decode_buffer(dst, dst_size, src, src_size, NULL,
	    APPLECORE_COMPRESSION_LZVN);
}

#endif /* _FASTCOMPRESSION_H_ */
