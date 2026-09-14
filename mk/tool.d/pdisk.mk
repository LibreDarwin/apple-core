# pdisk(8) -- the pdisk target's sources.  The directory also carries the
# classic Mac OS media layers (ATA, SCSI) and the cvt_pt and layout_dump
# utilities, none of which the target builds.
T_SRCS=		bitfield.c cmdline.c convert.c deblock_media.c dump.c errors.c \
		file_media.c hfs_misc.c io.c media.c partition_map.c \
		pathname.c pdisk.c util.c validate.c
T_CFLAGS+=	-D__unix__
T_LDADD+=	-framework CoreFoundation -framework IOKit
