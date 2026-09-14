# libmd -- installed as /usr/lib/libmd.dylib.  Most of it is generated:
# Apple's xcodescripts/generate_sources.sh stamps libmd/mdXhl.c out once
# per digest, and runs here against build/gen/libmd as it runs against
# BUILT_PRODUCTS_DIR in their build.
MD_GEN=		${TOP}/build/gen/libmd
_MD_HL=		md4hl.c md5hl.c shahl.c sha1hl.c sha224hl.c sha256hl.c \
		sha384hl.c sha512hl.c
T_SRCS=		sha0c.c ${_MD_HL:S|^|build/gen/libmd/|}
# -iquote, not -I: the generated sources say #include "md5.h", and the
# global -I include comes first, where include/md5.h -- a CommonCrypto
# shim for the tools that predate this library -- would be found instead.
# Quoted includes search -iquote directories before any -I.
T_CFLAGS+=	-std=gnu11 -iquote ${T_SRCDIR} -iquote ${TOP}/src/libmd/include \
		-I${TOP}/src/libmd/include

${MD_GEN}/.generated: ${TOP}/src/libmd/xcodescripts/generate_sources.sh \
		${T_SRCDIR}/mdXhl.c
	@mkdir -p ${MD_GEN}
	SRCROOT=${TOP}/src/libmd BUILT_PRODUCTS_DIR=${MD_GEN} \
	    sh ${TOP}/src/libmd/xcodescripts/generate_sources.sh
	@touch ${.TARGET}

.for f in ${_MD_HL}
${MD_GEN}/${f}: ${MD_GEN}/.generated
.endfor
