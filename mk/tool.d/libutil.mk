# libutil -- the util target's sources, from libutil.xcodeproj, followed
# by what mk/patches/libutil adds: FreeBSD's login_cap/getcap family
# (su, login, newgrp, getty, atrun, calendar) and sbuf.
T_SRCS=		ExtentManager.cpp getmntopts.c humanize_number.c pidfile.c \
		expand_number.c realhostname.c reexec_to_match_kernel.c \
		trimdomain.c tzlink.c tzbootuuid.c wipefs.cpp \
		getcap.c login_cap.c login_class.c login_ok.c login_times.c \
		_secure_path.c usbuf.c
T_CFLAGS+=	-I${T_SRCDIR}
