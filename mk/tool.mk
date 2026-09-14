# mk/tool.mk
#
# Per-program and per-library build driver.  Not meant to be invoked by
# hand; src/Makefile recurses into this file once per entry of
# mk/progs.mk, and lib/Makefile once per entry of mk/libs.mk:
#
#	bmake -f mk/tool.mk TOP=<repo> T_DIR=shell_cmds/date \
#	                     T_PROG=date T_BIN=bin
#	bmake -f mk/tool.mk TOP=<repo> T_KIND=lib T_DIR=libutil \
#	                     T_PROG=libutil T_BIN=usr/lib
#
# Sources live inside immutable submodules; every Makefile lives outside
# them and reaches in read-only.  A source that has to change is changed
# by a patch in mk/patches/<name>/, applied to a private copy of the
# submodule under build/src/<name>/ -- never to the submodule itself.
# Patches are written against the submodule root, as git format-patch
# produces them, and are applied with -p1 in name order.
#
# Optional per-entry customization belongs in mk/tool.d/<name>.mk,
# safely included when present.  Recognized knobs:
#
#	T_SRCS		override source list (basenames, or TOP-relative
#			paths for sources outside T_SRCDIR)
#	T_CFLAGS	extra compiler flags (C, Objective-C and C++ alike)
#	T_CXXFLAGS	extra flags for C++ sources only (e.g. -std=)
#	T_LDADD		extra libraries (e.g. -lncurses, ${LIBDIR}/libutil.a)
#	T_LINKS		extra names for the built file, in its install
#			directory: hardlinks beside a program (dc -> bc),
#			symlinks beside a script (bzcmp -> bzdiff) or a
#			dylib (libbz2.dylib -> libbz2.1.0.dylib)
#	T_INSTALLS	further files a fragment installs itself, relative
#			to build/release, for the stale check
#	T_NOBUILD	set to any value to turn the entry into a no-op
#
# Script tools set T_SCRIPT=<script basename>; the script is installed
# to the target location with the executable bit set.
#
# Libraries (T_KIND=lib) always produce build/lib/<name>.a, which is what
# the programs here link against, so the release tree runs in place
# without anything being installed.  Unless T_BIN is "-", the same
# objects are also linked into a dylib, installed where Apple installs
# it and under Apple's install name:
#
#	T_DYLIB		file name of the dylib (default <name>.dylib)
#	T_INSTALL_NAME	its install name (default /<T_BIN>/<T_DYLIB>)

TOP?=		${.CURDIR}

.include "${TOP}/mk/applecore.sys.mk"

T_KIND?=	prog
# Objects are keyed by entry name, not by source directory: fstyp.tproj
# builds four programs from one directory with different flags, and a
# shared objdir would let one link another's objects.  Entry names are
# unique by construction -- they are the installed file names.
T_OBJDIR?=	${TOP}/build/obj/${T_PROG}
# Sources are always discovered in the submodule, so a first build finds
# them before any patched copy exists.
T_ORIGDIR:=	${TOP}/src/${T_DIR}

_PATCHES!=	ls ${TOP}/mk/patches/${T_PROG}/*.patch 2>/dev/null || true
.if !empty(_PATCHES)
_SUBMOD:=	${T_DIR:C|/.*||}
T_COPYDIR:=	${TOP}/build/src/${T_PROG}
. if !empty(T_DIR:M*/*)
T_SRCDIR?=	${T_COPYDIR}/${T_DIR:C|^[^/]*/||}
. else
T_SRCDIR?=	${T_COPYDIR}
. endif
.else
T_SRCDIR?=	${T_ORIGDIR}
.endif

# Header dependencies.  Without these an object depends only on its own
# source, so editing a header rebuilds nothing and the link quietly
# reuses a stale object.  -MD writes the list beside each object and -MP
# adds a phony target per header, so a header later deleted does not
# leave a rule nothing can satisfy.
T_CFLAGS+=	-MD -MP

# Per-entry fragment loads before everything below, so T_SRCS/T_SCRIPT/
# T_NOBUILD/T_DYLIB/etc. influence which branch runs.
sinclude ${TOP}/mk/tool.d/${T_PROG}.mk

.if ${T_KIND} == "lib"
T_ARCHIVE=	${LIBDIR}/${T_PROG}.a
. if ${T_BIN} != "-"
T_DYLIB?=	${T_PROG}.dylib
T_INSTALL_NAME?=	/${T_BIN}/${T_DYLIB}
T_TARGET?=	${RELEASE}/${T_BIN}/${T_DYLIB}
. endif
.else
T_TARGET?=	${RELEASE}/${T_BIN}/${T_PROG}
.endif

# `all' is always the default target, even when a fragment defines its
# own helper rules (e.g. codegen) that would otherwise come first.
.MAIN: all

# What this entry installs, relative to build/release, for the stale
# check in the top-level Makefile.
print-installs:
.if !empty(T_TARGET)
	@echo ${T_TARGET:S|^${RELEASE}/||}
. for l in ${T_LINKS}
	@echo ${T_TARGET:H:S|^${RELEASE}/||}/${l}
. endfor
.endif
.for f in ${T_INSTALLS}
	@echo ${f}
.endfor

# Whether this entry produced what it installs.  The recursions in
# src/Makefile and lib/Makefile ignore failures on purpose, so one
# broken entry does not stop the rest; this is the guard.
check:
.if defined(T_NOBUILD)
	@${ECHO} "NOBUILD: ${T_PROG}  (from src/${T_DIR})"
.else
. if !empty(T_ARCHIVE)
	@test -e ${T_ARCHIVE} || \
		{ ${ECHO} "MISSING: ${T_ARCHIVE:S|^${TOP}/||}  (from src/${T_DIR})"; exit 1; }
. endif
. if !empty(T_TARGET)
	@test -e ${T_TARGET} || \
		{ ${ECHO} "MISSING: ${T_TARGET:S|^${RELEASE}/||}  (from src/${T_DIR})"; exit 1; }
. endif
.endif

.if defined(T_NOBUILD)
all clean:
	@${ECHO} "skip: ${T_PROG} (T_NOBUILD)"
.elif defined(T_SCRIPT)

# ------------------------------------------------------------------
# Script tool: install the named script as the program.
# ------------------------------------------------------------------

T_SCRIPTFILE?=	${T_SRCDIR}/${T_SCRIPT}

all: ${T_TARGET}
.for l in ${T_LINKS}
	ln -sf ${T_PROG} ${T_TARGET:H}/${l}
.endfor
	@${ECHO} "built: ${T_BIN}/${T_PROG} (script)${T_LINKS:D (+${T_LINKS})}"

${T_TARGET}: ${T_SCRIPTFILE}
	@mkdir -p ${.TARGET:H}
	cp ${T_SCRIPTFILE} ${.TARGET}
	chmod 755 ${.TARGET}

clean:
	rm -f ${T_TARGET}
.for l in ${T_LINKS}
	rm -f ${T_TARGET:H}/${l}
.endfor

.else

# ------------------------------------------------------------------
# Compiled program or library.
# ------------------------------------------------------------------

.PATH: ${T_SRCDIR}

# ------------------------------------------------------------------
# Source resolution
#
# Explicit list wins (from mk/tool.d/<name>.mk); otherwise discover
# every .c/.m/.cc/.cpp/.y/.l file in the source directory.  Yacc and lex
# inputs are expanded to their generated C sources up front so the rest
# of the file deals only in compilable sources.
# ------------------------------------------------------------------
.if defined(T_SRCS)
SRCS=	${T_SRCS}
.else
_RAW!=		ls ${T_ORIGDIR}/*.c ${T_ORIGDIR}/*.m ${T_ORIGDIR}/*.cc ${T_ORIGDIR}/*.cpp ${T_ORIGDIR}/*.y ${T_ORIGDIR}/*.l 2>/dev/null || true
SRCS!=		for f in ${_RAW}; do basename "$$f"; done 2>/dev/null || true
.endif

_GEN=
.for s in ${SRCS}
. if ${s:M*.y} != ""
_GEN+=		${s:T:R}.tab.c
. elif ${s:M*.l} != ""
_GEN+=		${s:T}.lex.c
. else
_GEN+=		${s:T}
. endif
.endfor

OBJS=
.for g in ${_GEN}
. if ${g:M*.tab.c} != ""
OBJS+=		${T_OBJDIR}/${g:C/\.tab.c$/.tab.o/}
. else
OBJS+=		${T_OBJDIR}/${g:R}.o
. endif
.endfor

# ------------------------------------------------------------------
# The private, patched copy.  Everything under T_SRCDIR comes into
# being with the stamp, so each source is declared to depend on it.
# ------------------------------------------------------------------
.if !empty(_PATCHES)
_PATCHED=	${T_COPYDIR}/.patched

${_PATCHED}: ${_PATCHES}
	@${ECHO} "patch: ${T_PROG} <- ${_PATCHES:T}"
	@rm -rf ${T_COPYDIR} && mkdir -p ${T_COPYDIR}
	@rsync -a --exclude .git ${TOP}/src/${_SUBMOD}/ ${T_COPYDIR}/
	@cd ${T_COPYDIR} && for p in ${_PATCHES}; do \
		patch -s -p1 < $$p || { ${ECHO} "patch: $$p does not apply"; exit 1; }; \
	done
	@touch ${.TARGET}

. for s in ${SRCS:N*/*}
${T_SRCDIR}/${s}: ${_PATCHED}
. endfor
.endif

# ------------------------------------------------------------------
# Rules -- objects compile straight into T_OBJDIR so builds never
# write inside the submodules.  bmake does not apply suffix transforms
# to objdir-qualified targets, so every rule is spelled out.
# ------------------------------------------------------------------

.if ${T_KIND} == "lib"
all: ${T_ARCHIVE} ${T_TARGET}
. for l in ${T_LINKS}
	ln -sf ${T_TARGET:T} ${T_TARGET:H}/${l}
. endfor
	@${ECHO} "built: ${T_ARCHIVE:S|^${TOP}/||}${T_TARGET:D, ${T_TARGET:S|^${RELEASE}/||}}${T_LINKS:D (+${T_LINKS})}"
.else
all: ${T_TARGET}
. for l in ${T_LINKS}
	ln -f ${T_TARGET} ${T_TARGET:H}/${l}
. endfor
	@${ECHO} "built: ${T_BIN}/${T_PROG}${T_LINKS:D (+${T_LINKS})}"
.endif

.for s in ${SRCS}
. if ${s:M*/*} != ""
# Source outside T_SRCDIR: T_SRCS entry is a path relative to TOP.
# Dispatch on the suffix, so a mixed C and C++ list gets the right
# driver and the right flags for each.
.  if ${s:M*.cc} != "" || ${s:M*.cpp} != ""
${T_OBJDIR}/${s:T:R}.o: ${TOP}/${s}
	@mkdir -p ${T_OBJDIR}
	${CXX} ${CPPFLAGS} ${CXXFLAGS} ${T_CFLAGS} ${T_CXXFLAGS} -c ${TOP}/${s} -o ${.TARGET}
.  else
${T_OBJDIR}/${s:T:R}.o: ${TOP}/${s}
	@mkdir -p ${T_OBJDIR}
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${TOP}/${s} -o ${.TARGET}
.  endif
. elif ${s:M*.y} != ""
# Yacc: foo.y -> foo.tab.c + foo.tab.h -> foo.tab.o
${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	cd ${T_OBJDIR} && ${YACC} -d ${T_SRCDIR}/${s} && \
	    mv y.tab.c ${s:T:R}.tab.c && mv y.tab.h ${s:T:R}.tab.h

${T_OBJDIR}/${s:T:R}.tab.o: ${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h
	${CC} ${CPPFLAGS} -I${T_OBJDIR} ${CFLAGS} ${T_CFLAGS} -c ${T_OBJDIR}/${s:T:R}.tab.c -o ${.TARGET}
. elif ${s:M*.l} != ""
# Lex: foo.l -> foo.l.lex.c -> foo.l.lex.o
${T_OBJDIR}/${s:T}.lex.c: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${LEX} -t ${T_SRCDIR}/${s} > ${.TARGET}

${T_OBJDIR}/${s:T}.lex.o: ${T_OBJDIR}/${s:T}.lex.c
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${T_OBJDIR}/${s:T}.lex.c -o ${.TARGET}
. elif ${s:M*.cc} != "" || ${s:M*.cpp} != ""
# C++ source.  Compile the named source explicitly (not ${.ALLSRC}) so a
# fragment may add generated-header prerequisites without feeding them to
# the compiler.
${T_OBJDIR}/${s:T:R}.o: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${CXX} ${CPPFLAGS} ${CXXFLAGS} ${T_CFLAGS} ${T_CXXFLAGS} -c ${T_SRCDIR}/${s} -o ${.TARGET}
. else
# C or Objective-C source -- clang tells them apart by suffix.  Compile
# the named source explicitly (not ${.ALLSRC}) so header prerequisites
# added by a fragment are not passed to clang.
${T_OBJDIR}/${s:T:R}.o: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${T_SRCDIR}/${s} -o ${.TARGET}
. endif
.endfor

# Link with the C++ driver when any source is C++ (pulls libc++ in).
_LINKER=	${CC}
.for s in ${SRCS}
. if ${s:M*.cc} != "" || ${s:M*.cpp} != ""
_LINKER=	${CXX}
. endif
.endfor

# Pull in what the last compile recorded.  sinclude so that a first
# build, with no .d files yet, is not an error.  ":=" so the paths are
# flattened now: SRCS comes from a "!=" command and a ".for" over its
# words expands to nested expressions, which an include directive --
# needing its path while the makefile is read -- does not resolve.
_DEPS:=		${_GEN:@g@${T_OBJDIR}/${g:R}.d@}
.for d in ${_DEPS}
.sinclude "${d}"
.endfor

.if ${T_KIND} == "lib"
${T_ARCHIVE}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	@rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${OBJS}

. if !empty(T_TARGET)
${T_TARGET}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	${_LINKER} -dynamiclib -install_name ${T_INSTALL_NAME} \
	    -o ${.TARGET} ${OBJS} ${LDFLAGS} ${T_LDADD}
. endif
.else
${T_TARGET}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	${_LINKER} -o ${.TARGET} ${OBJS} ${LDFLAGS} ${T_LDADD}
.endif

clean:
	rm -rf ${T_OBJDIR} ${T_ARCHIVE} ${T_TARGET} ${T_COPYDIR}
.for l in ${T_LINKS}
	rm -f ${T_TARGET:H}/${l}
.endfor

.endif
