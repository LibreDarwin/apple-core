# mk/with-bash.mk
#
# Shared fragment: the one configuration bash.xcodeproj gives bash and every
# library it links -- builtins, intl, readline, libsh and glob.  Apple's
# config.h, pathnames.h, signames.h and version.h sit at the top of the
# submodule.  Their USER_HEADER_SEARCH_PATHS is $(SRCROOT)/**; these are
# the directories under it the sources actually reach.
#
#	.include "${TOP}/mk/with-bash.mk"
#
# Include it after T_SRCS: every object waits for the generated ostype.h.

BASH_SRC=	${TOP}/src/bash/bash-3.2
BASH_GEN=	${TOP}/build/gen/bash
# conftypes.h names the host type itself for ppc, x86 and 32-bit arm, and
# for anything else -- arm64 -- falls back to CONF_HOSTTYPE, which bash's
# own Makefile.in defines from the machine name.  So does this.
_BASH_ARCH!=	uname -m

T_CFLAGS+=	-std=gnu99 -Werror=format-security \
		-DM_UNIX -DIN_LIBINTL -DLIBDIR='"/usr/libdata"' \
		-DLOCALEDIR='"/usr/share/locale"' \
		-DLOCALE_ALIAS_PATH='"/usr/share/locale"' -DPACKAGE='"BASH"' \
		-DSSH_SOURCE_BASHRC -DCONF_VENDOR='"apple"' \
		-DCONF_MACHTYPE='"Mac"' -DCONF_HOSTTYPE='"${_BASH_ARCH}"' \
		-DMACOSX -DSHELL -DHAVE_CONFIG_H \
		-I${BASH_GEN} -I${TOP}/src/bash -I${BASH_SRC} -I${BASH_SRC}/include \
		-I${BASH_SRC}/lib -I${BASH_SRC}/builtins -I${BASH_SRC}/lib/intl

# ostype.h is generated, as Apple's "ostype.h" aggregate target generates it:
# OSTYPE is "darwin" and the major version of the running kernel.
${BASH_GEN}/ostype.h:
	@mkdir -p ${.TARGET:H}
	printf '#ifndef __OSTYPE__\n#define __OSTYPE__\n\n#define OSTYPE "darwin%s"\n#endif /* __OSTYPE__ */\n' \
	    "$$(uname -r | cut -d. -f1)" > ${.TARGET}

# The grammar's object is <name>.tab.o, so both spellings are covered.
.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o ${T_OBJDIR}/${s:T:R}.tab.o: ${BASH_GEN}/ostype.h
.endfor
