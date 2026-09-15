# kcditto(8) -- the kcditto target of kext_tools.xcodeproj, built
# standalone as Apple's target builds it.
#
# Its private headers are kextcache's, in include/ (see kextcache.mk), and
# it links libbless statically as Apple's does.  Stock kcditto links
# libCoreStorage, libcsfde, EFILogin, Bom, DiskArbitration and APFS beside
# what every kext tool links.
T_SRCS=		fork_program.c safecalls.c kext_tools_util.c bootcaches.c \
		kcditto_main.m signposts.m kc_staging.m
T_CFLAGS+=	-std=gnu11 -DDEBUG=1 -DKCDITTO_STANDALONE_BINARY -DROSP_HACKS \
		-I${TOP}/src/bless/libbless -F${TOP}/frameworks
.include "${TOP}/mk/with-kext_tools.mk"
T_LDADD+=	${LIBDIR}/libbless.a -framework DiskArbitration \
		-F/System/Library/PrivateFrameworks -framework APFS \
		-framework Bom -framework EFILogin -lCoreStorage -lcsfde
