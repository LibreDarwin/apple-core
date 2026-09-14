# lsof(8), from Apple's drop.  lsof has no autoconf: its own Configure
# script, run for the darwin dialect with -n (no questions asked),
# writes the Makefiles, and make builds the one binary in the tree.
# Configure looks for the system headers in /usr/include, which macOS no
# longer has; Apple's wrapper points it at the SDK instead, and so does
# this.
#
# BLOCKED: dialects/darwin/libproc/dlsof.h includes <sys/vsock_private.h>,
# which is in no SDK or source tree on this machine (the ravynos xnu tree
# predates it).
P_NOBUILD=	yes

SDKROOT!=	xcrun --show-sdk-path
P_BUILDSYS=	make
P_PREPARE=	LSOF_INCLUDE=${SDKROOT}/usr/include \
		LSOF_CFGF="-isysroot ${SDKROOT} -idirafter ${TOP}/include" \
		./Configure -n darwin
P_NOSTAGE=	yes
P_PROGS=	lsof
