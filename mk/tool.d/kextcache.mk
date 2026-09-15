# kextcache(8) -- the kextcache target of kext_tools.xcodeproj.
#
# Beyond kextload's private headers it needs Bom/Bom.h, EFILogin/EFILogin.h,
# the three CoreStorage headers under IOKit/storage/CoreStorage/ and
# FastCompression.h, all in include/ and each recovered from the shipped
# binaries (see the headers).  FastCompression.h is the one stand-in rather
# than a declaration: Apple's lzvn coder is a static library they do not
# ship, so it maps the three lzvn calls onto libcompression's raw LZVN.
#
# libbless is bless.xcodeproj's, linked statically as Apple's is; APFS
# comes from the staged framework headers.  What stock kextcache links
# beyond every kext tool: KernelManagement, APFS, Bom, DiskArbitration,
# CoreGraphics, EFILogin, Security, SystemPolicy, CoreText, libCoreStorage,
# libcsfde and libz.
_KT=		${T_COPYDIR:S|^${TOP}/||}
T_SRCS=		kextcache_main.c staging.m update_boot.c syspolicy.m \
		compression.c bootcaches.c driverkit.m mkext1_file.c \
		safecalls.c kc_staging.m kext_tools_util.c signposts.m \
		fork_program.c kernelcache.c security.c \
		${_KT}/KernelManagementShims/kextcache.m \
		${_KT}/KernelManagementShims/Shims.m \
		${_KT}/KernelManagementShims/ShimHelpers.m
T_CFLAGS+=	'-DPRODUCT_NAME="kextcache"' -DDEV_KERNEL_SUPPORT -DROSP_HACKS \
		-I${TOP}/src/bless/libbless -F${TOP}/frameworks -I${KMM_GEN}

# update_boot.c includes <IOKit/kext/kextmanager_mig.h>, the MIG header of
# IOKitUser's kextmanager_mig.defs (staged in include/).  IOKit itself
# exports the client routines -- stock kextcache imports
# kextmanager_lock_volume and kextmanager_unlock_volume from it -- so only
# the header is generated.
KMM_GEN=	${TOP}/build/gen/kextmanager_mig
${KMM_GEN}/IOKit/kext/kextmanager_mig.h: ${TOP}/include/IOKit/kext/kextmanager_mig.defs
	@mkdir -p ${KMM_GEN}/IOKit/kext
	cd ${KMM_GEN}/IOKit/kext && ${MIG} -I${TOP}/include \
	    -user /dev/null -server /dev/null -header kextmanager_mig.h \
	    ${TOP}/include/IOKit/kext/kextmanager_mig.defs
.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${KMM_GEN}/IOKit/kext/kextmanager_mig.h
.endfor
.include "${TOP}/mk/with-kext_tools.mk"
T_LDADD+=	${LIBDIR}/libbless.a \
		-framework KernelManagement -framework Security \
		-framework DiskArbitration -framework CoreGraphics \
		-framework CoreText \
		-F/System/Library/PrivateFrameworks -framework SystemPolicy \
		-framework APFS -framework Bom -framework EFILogin \
		-lCoreStorage -lcsfde -lz -lcompression
