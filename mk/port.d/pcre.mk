# pcre -- PCRE 8.44, which stock macOS ships as /usr/lib/libpcre.0.dylib
# and zsh's pcre module links.  Apple's drop is the upstream tarball plus
# three patches, built by their Makefile with the flags below; this does
# the same, out of tree.
#
# Only the libraries are installed.  The headers and pcre-config stay in
# the stage, where zsh's configure finds them (mk/port.d/zsh.mk).
PCRE_V=		8.44
P_PREPARE=	tar -jxf pcre-${PCRE_V}.tar.bz2 && mv pcre-${PCRE_V} pcre && \
		for p in Makefile.in.diff no-programs.diff configure.diff; do \
		    (cd pcre && patch -s -p0 < ../files/$$p) || exit 1; \
		done
# Apple's Makefile exports a 13.0 deployment target.  It matters beyond
# the minimum OS: libtool picks -flat_namespace for a target it reads as
# 10.0 -- what it assumes when none is set -- and today's linker refuses
# that for a library eligible for the shared cache.
P_ENV=		MACOSX_DEPLOYMENT_TARGET=13.0
P_CONFIGURE=	pcre/configure
P_OBJDIR=	${P_WORKDIR}/build
P_PREFIX=	/usr/local
P_CONFIGURE_ARGS=	--libdir=/usr/lib --disable-static \
			--enable-unicode-properties --disable-cpp
P_MAKE_ARGS=	EXTRA_LIBPCRE_LDFLAGS="-version-info 0:1:0" \
		EXTRA_LIBPCREPOSIX_LDFLAGS="-version-info 0:0:0"
P_PROGS=
P_RELEASE_FILES=	../lib/libpcre.0.dylib usr/lib/libpcre.0.dylib \
			../lib/libpcreposix.0.dylib usr/lib/libpcreposix.0.dylib
P_RELEASE_SYMLINK=	usr/lib/libpcre.0.dylib usr/lib/libpcre.dylib \
			usr/lib/libpcreposix.0.dylib usr/lib/libpcreposix.dylib
