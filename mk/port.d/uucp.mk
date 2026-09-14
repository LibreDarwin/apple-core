# uucp, from Apple's drop: Taylor UUCP under uucp/, configured with the
# two flags Apple's wrapper Makefile passes.  The user programs go to
# usr/bin -- uuto, a script, among them -- and the daemons and administration tools to usr/sbin, as stock
# macOS has them.
P_CONFIGURE_ARGS=	--with-newconfigdir=/private/etc/uucp --with-user=_uucp
P_PROGS=		bin/uux bin/uucp bin/uustat bin/uuname bin/uulog \
			bin/uupick bin/cu bin/uuto
P_RELEASE_FILES=	sbin/uucico usr/sbin/uucico \
			sbin/uuxqt usr/sbin/uuxqt \
			sbin/uuchk usr/sbin/uuchk \
			sbin/uuconv usr/sbin/uuconv \
			sbin/uusched usr/sbin/uusched
