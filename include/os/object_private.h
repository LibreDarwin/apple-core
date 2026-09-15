/*
 * <os/object_private.h> -- apple-core's stand-in.
 *
 * libsystem_asl's private headers include it, but nothing in the tree
 * uses more than <os/object.h>'s public OS_OBJECT_CONSUMED.  Only that
 * much is provided; add _os_object SPI here, read from the shipped
 * libsystem_blocks/libdispatch, when a source needs it.
 */
#ifndef __OS_OBJECT_PRIVATE__
#define __OS_OBJECT_PRIVATE__

#include <os/object.h>

#endif /* __OS_OBJECT_PRIVATE__ */
