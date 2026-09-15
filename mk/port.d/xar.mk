# xar(1), from Apple's drop: upstream's tree under xar/, with a configure
# already generated.  Configured out of tree, since the copy's own xar/
# directory would collide with the default object directory.
#
# libxml2's headers come from the SDK: -iwithsysroot finds usr/include/
# libxml2 inside it, where an absolute -I would look on the host.  In
# CPPFLAGS, not CFLAGS, because the dependency pass runs $(CC) -MM
# $(CPPFLAGS) alone.  archive.h includes <CommonCrypto/CommonDigestSPI.h>,
# which include/ carries; -idirafter keeps the rest of include/ behind the
# SDK.  src/ includes filetree.h from lib/, which nothing else points at.
SDKROOT!=	xcrun --show-sdk-path
XAR_SRC=	${P_WORKDIR}/src/xar
P_CONFIGURE=	xar/configure
P_OBJDIR=	${P_WORKDIR}/build
P_CONFIGURE_ARGS=	CPPFLAGS='-isysroot ${SDKROOT} -iwithsysroot /usr/include/libxml2 -I${XAR_SRC}/lib -idirafter ${TOP}/include' \
			CFLAGS='-isysroot ${SDKROOT}'
# xar's sources say #include <xar/xar.h>, the installed layout; configure
# generates include/xar.h one directory short.  A xar -> . link in the
# build tree bridges it without touching sources or Makefile.
P_POST_CONFIGURE=	ln -sfn . include/xar
P_PROGS=	bin/xar
P_LIBS=		lib/libxar.1.dylib
