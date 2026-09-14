# file(1) -- the file target's sources, with what common.xcconfig gives
# them: Apple's config.h at the top of the submodule, the database path,
# and BUILTIN_MACHO.  lzma.h is the liblzma tree vendored for grep; the SDK
# stubs the library but ships no header.
#
# The compiled database is made the way Apple's xcodescripts/magic.sh
# makes it -- the new file(1) run with -C over upstream's Magdir -- and
# installed as usr/share/file/magic.mgc.
T_SRCS=	apprentice.c apptype.c ascmagic.c buffer.c cdf_time.c cdf.c \
		compress.c der.c encoding.c fsmagic.c funcs.c is_csv.c \
		is_json.c is_tar.c magic.c print.c readcdf.c readelf.c \
		readmacho.c softmagic.c file.c
T_CFLAGS+=	-DHAVE_CONFIG_H '-DMAGIC="/usr/share/file/magic"' -DBUILTIN_MACHO \
		-I${TOP}/src/file -I${T_SRCDIR} -I${TOP}/include/liblzma
T_LDADD+=	-lbz2 -lz -llzma

MAGIC_MGC=	${RELEASE}/usr/share/file/magic.mgc
T_INSTALLS=	usr/share/file/magic.mgc

all: ${MAGIC_MGC}

${MAGIC_MGC}: ${RELEASE}/${T_BIN}/${T_PROG}
	@mkdir -p ${.TARGET:H} ${T_OBJDIR}/magic
	cd ${T_OBJDIR}/magic && ${RELEASE}/${T_BIN}/${T_PROG} -C \
	    -m ${TOP}/src/file/file/magic/Magdir
	cp ${T_OBJDIR}/magic/Magdir.mgc ${.TARGET}
