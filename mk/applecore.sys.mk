# mk/applecore.sys.mk
#
# Global build knobs shared by every driver Makefile in this tree.
# Everything is built with BSD bmake(1); no GNU make idioms are used.
#
# Layout:
#
#	build/			generated; safe to delete at any time
#	build/lib/		static archives the programs link against
#	build/obj/<name>/	per-program and per-library objects
#	build/gen/<name>/	build-time generated sources
#	build/src/<name>/	private copies of submodules, with the
#				patches in mk/patches/<name>/ applied
#	build/ports/<name>/	work directories of the ports
#	build/release/		the product, laid out as the root of a stock
#				macOS install:
#		bin/ sbin/ usr/bin/ usr/sbin/ usr/libexec/ usr/lib/
#
# Placements mirror where stock macOS keeps each file (see mk/progs.mk,
# mk/libs.mk and mk/ports.mk).

TOP?=		${.CURDIR}

RELEASE=	${TOP}/build/release
LIBDIR=		${TOP}/build/lib

CC?=		cc
CXX?=		c++
CPPFLAGS+=	-I${TOP}/include -I${TOP}/build/include

# bmake predefines CC (as "cc -pipe"), CFLAGS (as "-O2") and CXXFLAGS in
# its own sys.mk, so `?=' here is silently a no-op -- as it was for as
# long as this file said `CFLAGS?=': nothing was ever built with -g or
# -Wall.  Assign plainly; a command-line `bmake CFLAGS=...' still wins.
CFLAGS=		-O2 -g -Wall -Wno-unused-parameter
CXXFLAGS=	${CFLAGS}

# Reproducible links.  With -g, ld records each object file's mtime in
# the debug map (N_OSO stab) and folds that into LC_UUID, so two clean
# builds of identical sources would otherwise differ byte for byte.
LDFLAGS+=	-Wl,-reproducible

AR?=		ar
MIG?=		mig
YACC?=		yacc
LEX?=		lex

ECHO=		echo

#
# Optional tiers, all off by default; the default build is the
# coreutils-like set.  Enable any combination, e.g.
#
#	bmake MK_DIAGNOSTICS=yes MK_PORTS=yes
#
#	MK_DIAGNOSTICS		system diagnostics and developer tools
#	MK_DAEMONS		network and service daemons
#	MK_PRIVATE_FRAMEWORKS	tools linking frameworks the public SDK
#				does not ship
#	MK_PORTS		components built through their own build
#				system by mk/port.mk -- off because each
#				runs a full configure and make
#
# The tiers are gated where their entries are listed (mk/progs.mk,
# mk/ports.mk), so every name is written in exactly one place.
#
MK_DIAGNOSTICS?=	no
MK_DAEMONS?=		no
MK_PRIVATE_FRAMEWORKS?=	no
MK_PORTS?=		no

# Per-entry opt-outs, for leaving one entry out without editing the
# inventory:  bmake DISABLED_PROGS="ifconfig su"
DISABLED_PROGS?=

.PHONY: all clean
