# tcsh(1), and csh, the hardlink Apple's wrapper Makefile makes to it.
# Configured as that Makefile configures it; _PATH_TCSHELL is what $shell
# reports, and DARWIN selects the Darwin code paths.
#
# Taken straight from the build directory: the one binary is all that is
# installed.
P_CONFIGURE_ARGS=	--bindir=/bin ac_cv_func_sbrk=no \
			CPPFLAGS='-D_PATH_TCSHELL=\"/bin/tcsh\" -DDARWIN'
P_NOSTAGE=		yes
P_PROGS=		tcsh
P_LINKS=		csh
