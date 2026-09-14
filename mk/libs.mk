# mk/libs.mk - the library inventory.
#
# One entry per library, three whitespace-separated fields:
#
#	LIBS+=	<dir-under-src> <library-name> <install-suffix>
#
#   <dir>             directory containing the sources, under src/
#                     (../lib/... reaches the submodules kept in lib/)
#   <library-name>    base name; build/lib/<name>.a is always built,
#                     and is what the programs link
#   <install-suffix>  where Apple installs the dylib, under build/release/
#                     and named by its INSTALL_PATH in Apple's project --
#                     or "-" for a library Apple only links statically,
#                     which gets the archive alone
#
# Sources and flags are in mk/tool.d/<library-name>.mk, as for programs.
# Libraries build before ports and programs, which link them through
# mk/with-*.mk.

# libutil: the util target of libutil.xcodeproj, installed as
# /usr/lib/libutil.dylib, plus FreeBSD's login_cap and sbuf families
# from mk/patches/libutil.
LIBS+=	libutil libutil usr/lib

# The crypto-free half of libtelnet, which Apple links statically.
LIBS+=	libtelnet libtelnet -

# libxo (lib/libxo), for the tools that print through it.  Apple ships
# no libxo; it is linked statically.
LIBS+=	../lib/libxo/libxo libxo -

# Helpers shared by the network_cmds tools, network_cmds_lib in Apple's
# project -- static there too.
LIBS+=	network_cmds/network_cmds_lib libnetcmds -

# fsck_hfs' checking engine, which Apple builds into the fsck_hfs binary.
LIBS+=	hfs/lib_fsck_hfs libfsck_hfs -

# zlib, bzip2 and libmd, as /usr/lib has them.
LIBS+=	zlib/zlib libz usr/lib
LIBS+=	bzip2/bzip2 libbz2 usr/lib
LIBS+=	libmd/libmd libmd usr/lib

# libSystem's copyfile and removefile sub-libraries, in /usr/lib/system.
LIBS+=	copyfile libcopyfile usr/lib/system
LIBS+=	removefile libremovefile usr/lib/system

# libtidy, as /usr/lib/libtidy.A.dylib -- the one tidy(1) links.
LIBS+=	tidy/tidy/src libtidy usr/lib

# top's sampling library, static in Apple's build.
LIBS+=	top libtop -

# libipsec, as /usr/lib/libipsec.A.dylib, for setkey(8).
LIBS+=	ipsec/ipsec-tools/libipsec libipsec usr/lib

# What bash(1) links, all static in Apple's build: its builtins, and the
# intl, readline, sh and glob libraries bash 3.2 carries.
LIBS+=	bash/bash-3.2/builtins libbuiltins -
LIBS+=	bash/bash-3.2/lib/intl libintl -
LIBS+=	bash/bash-3.2/lib/readline libreadline -
LIBS+=	bash/bash-3.2/lib/sh libsh -
LIBS+=	bash/bash-3.2/lib/glob libglob -
