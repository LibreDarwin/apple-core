# mk/with-libutil.mk
#
# Shared fragment: link against libutil, built by lib/Makefile.
#
#	.include "${TOP}/mk/with-libutil.mk"
#
# Headers come from the patched copy in build/src/libutil: login_cap.h,
# and the libutil.h that declares the login_cap/getcap and sbuf families,
# only exist once mk/patches/libutil is applied.  lib/Makefile runs
# before the programs, so the copy is always there by the time a program
# compiles.
T_CFLAGS+=	-I${TOP}/build/src/libutil
T_LDADD+=	${LIBDIR}/libutil.a
