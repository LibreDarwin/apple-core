# mk/port.mk
#
# Build driver for components that carry their own build system --
# autoconf, CMake, or a plain Makefile -- which we drive rather than
# compile ourselves.  The counterpart to mk/tool.mk.
#
# Not meant to be invoked by hand; ports/Makefile recurses into this
# file once per entry of mk/ports.mk:
#
#	bmake -f mk/port.mk TOP=<repo> P_DIR=less/less P_NAME=less P_BIN=usr/bin
#
# Everything happens outside the submodule.  By default the source is
# copied into build/ports/<name>/src and built there; with P_COPY=no it
# is configured VPATH-style from build/ports/<name>/build instead.  Either
# way the submodule is never written to.
#
# Patches in mk/patches/<name>/ are applied to the copy, in name order,
# before P_PREPARE.  As for mk/tool.mk they are written against the
# submodule root, as git format-patch in the submodule produces them;
# the strip count is worked out from how deep P_DIR sits in it.
#
# Per-port customization belongs in mk/port.d/<name>.mk.  Recognized
# knobs:
#
#	P_PROGS		programs to install, relative to the staged prefix
#			(default: bin/${P_NAME}), into build/release/<suffix>
#	P_LIBS		libraries to install, relative to the same prefix,
#			into P_LIBDIR (default build/release/usr/lib)
#	P_LINKS		extra names hardlinked beside each program
#	P_RELEASE_TREES	directories to install anywhere in the release
#			tree, as alternating <src> <dest> words: <src>
#			relative to where P_PROGS reads from, <dest>
#			relative to build/release.  Each replaces what is
#			there.
#	P_RELEASE_MERGE	like P_RELEASE_TREES, merged into the destination
#			rather than replacing it -- for directories several
#			ports each add to (usr/share/man, say)
#	P_RELEASE_SYMLINK  pairs of <target> <linkname>, both relative to
#			build/release: one relative symlink apiece
#	P_BUILDSYS	"autoconf" (default), "cmake", or "make" for a
#			project that ships a Makefile and no configure step
#	P_CONFIGURE	configure script, relative to the source dir
#			(autoconf only; default: configure)
#	P_CONFIGURE_ARGS  extra arguments to configure / cmake
#	P_CMAKE_SRC	directory holding the top CMakeLists.txt, relative
#			to the source dir (default .)
#	P_MAKE		make(1) to drive the port with (default: make,
#			which is GNU make on macOS; ninja for cmake)
#	P_MAKE_ARGS	extra arguments to make
#	P_COPY		"no" to configure VPATH-style from the submodule
#			(the default for cmake ports).  Old autoconf trees
#			have rules that only work in tree, so copying is
#			the default otherwise.
#	P_PREPARE	shell command run inside the copied, patched tree
#			before configure
#	P_POST_CONFIGURE  shell command run in the build directory after
#			configure and before make
#	P_POST_BUILD	shell command run in the build directory after the
#			build, before anything is copied out of it
#	P_POST_STAGE	shell command run in the source tree after the
#			install step; the staged prefix is
#			${P_STAGEDIR}${P_PREFIX}
#	P_PREFIX	the prefix the port is configured for (default /usr)
#	P_NOSTAGE	set to take P_PROGS straight out of the build
#			directory rather than running the install step
#	P_NOBUILD	set to any value to turn the entry into a no-op
#	P_NO_AUTOTOOLS_FLAGS  "yes" to leave out --disable-dependency-
#			tracking and --disable-nls, for a configure that
#			rejects them

TOP?=		${.CURDIR}

.include "${TOP}/mk/applecore.sys.mk"

P_SRCDIR?=	${TOP}/src/${P_DIR}
P_WORKDIR?=	${TOP}/build/ports/${P_NAME}
P_STAGEDIR?=	${P_WORKDIR}/stage
P_BINDIR?=	${RELEASE}/${P_BIN}
P_LIBDIR?=	${RELEASE}/usr/lib

sinclude ${TOP}/mk/port.d/${P_NAME}.mk

.MAIN: all

P_BUILDSYS?=		autoconf
P_CONFIGURE?=		configure
P_NO_AUTOTOOLS_FLAGS?=	no
P_PREFIX?=		/usr
P_CMAKE_SRC?=		.

# Computed at parse time: a .if inside a tab-indented recipe line is
# handed to the shell literally.
.if ${P_NO_AUTOTOOLS_FLAGS:tl} == "yes"
_AUTOTOOLS_FLAGS?=
.else
_AUTOTOOLS_FLAGS?=	--disable-dependency-tracking --disable-nls
.endif

.if ${P_BUILDSYS:tl} == "cmake"
# CMake builds out of tree properly, so there is no reason to copy.
P_COPY?=		no
P_MAKE?=		ninja
.else
P_MAKE?=		make
.endif
P_PROGS?=		bin/${P_NAME}
P_COPY?=		yes

_PATCHES!=	ls ${TOP}/mk/patches/${P_NAME}/*.patch 2>/dev/null || true
_PATCH_P!=	echo $$((1 + $$(printf '%s' '${P_DIR}' | tr -cd / | wc -c)))

.if ${P_COPY:tl} == "yes"
# In tree: configure and build happen inside our private copy.
P_BUILDSRC=	${P_WORKDIR}/src
P_OBJDIR?=	${P_WORKDIR}/src
P_CONFDEP=	${P_WORKDIR}/.copied
.else
# Out of tree: build beside the submodule, which stays read-only.
. if !empty(_PATCHES)
.  error ${P_NAME}: mk/patches/${P_NAME} needs a copy to apply to; drop P_COPY=no
. endif
P_BUILDSRC=	${P_SRCDIR}
P_OBJDIR?=	${P_WORKDIR}/build
P_CONFDEP=
.endif

# A port's configure arguments are written in mk/port.d/<name>.mk, so a
# change there has to reconfigure -- otherwise the .configured stamp,
# once it exists, means the edit silently never takes effect.
.if exists(${TOP}/mk/port.d/${P_NAME}.mk)
P_CONFDEP+=	${TOP}/mk/port.d/${P_NAME}.mk
.endif

.if defined(P_NOSTAGE)
P_PROGSRC=	${P_OBJDIR}
.else
P_PROGSRC=	${P_STAGEDIR}${P_PREFIX}
.endif

# What this port installs, relative to build/release, for the stale
# check in the top-level Makefile.
print-installs:
.for f in ${P_PROGS}
	@echo ${P_BIN}/${f:T}
. for l in ${P_LINKS}
	@echo ${P_BIN}/${l}
. endfor
.endfor
.for l in ${P_LIBS}
	@echo ${P_LIBDIR:S|^${RELEASE}/||}/${l:T}
.endfor
.for tgt lnk in ${P_RELEASE_SYMLINK}
	@echo ${lnk}
.endfor
.for src dst in ${P_RELEASE_MERGE}
	@ls -A ${P_PROGSRC}/${src} 2>/dev/null | sed 's|^|${dst}/|'
.endfor

.if defined(P_NOBUILD)
all clean check:
	@${ECHO} "skip: ${P_NAME} (P_NOBUILD)"
.else

.if defined(P_NOSTAGE)
all: ${P_WORKDIR}/.built
.else
all: ${P_WORKDIR}/.staged
.endif
.for f in ${P_PROGS}
	@mkdir -p ${P_BINDIR}
	@rm -f ${P_BINDIR}/${f:T}
	@cp ${P_PROGSRC}/${f} ${P_BINDIR}/${f:T}
	@chmod u+w ${P_BINDIR}/${f:T}
. for l in ${P_LINKS}
	@ln -f ${P_BINDIR}/${f:T} ${P_BINDIR}/${l}
. endfor
.endfor
	@${ECHO} "built: ${P_BIN}/${P_PROGS:T}${P_LINKS:D (+${P_LINKS})}"
.for l in ${P_LIBS}
	@mkdir -p ${P_LIBDIR}
	@rm -f ${P_LIBDIR}/${l:T}
	@cp ${P_PROGSRC}/${l} ${P_LIBDIR}/${l:T}
	@${ECHO} "staged: ${P_LIBDIR:S|^${RELEASE}/||}/${l:T}"
.endfor
.for src dst in ${P_RELEASE_TREES}
	@mkdir -p ${RELEASE}/${dst:H}
	@rm -rf ${RELEASE}/${dst}
	@cp -R ${P_PROGSRC}/${src} ${RELEASE}/${dst}
	@${ECHO} "staged: ${dst}/"
.endfor
.for src dst in ${P_RELEASE_MERGE}
	@mkdir -p ${RELEASE}/${dst}
	@cp -R ${P_PROGSRC}/${src}/. ${RELEASE}/${dst}/
	@${ECHO} "staged: ${dst}/ (merged)"
.endfor
.for tgt lnk in ${P_RELEASE_SYMLINK}
	@mkdir -p ${RELEASE}/${lnk:H}
	@rm -rf ${RELEASE}/${lnk}
	@cd ${RELEASE}/${lnk:H} && \
	    ln -s "$$(python3 -c 'import os,sys;print(os.path.relpath(sys.argv[1],sys.argv[2]))' \
		${RELEASE}/${tgt} "$$PWD")" ${lnk:T}
	@${ECHO} "linked: ${lnk} -> ${tgt}"
.endfor

# --- copy and patch ---------------------------------------------------

${P_WORKDIR}/.copied: ${_PATCHES}
	@mkdir -p ${P_WORKDIR}
	@${ECHO} "port: copying ${P_NAME} sources"
	@rsync -a --delete --exclude '.git' ${P_SRCDIR}/ ${P_BUILDSRC}/
.for p in ${_PATCHES}
	@${ECHO} "port: ${P_NAME}: applying ${p:T}"
	@cd ${P_BUILDSRC} && patch -s -p${_PATCH_P} < ${p}
.endfor
.if defined(P_PREPARE)
	@${ECHO} "port: preparing ${P_NAME}"
	@cd ${P_BUILDSRC} && ${P_PREPARE}
.endif
	@touch ${.TARGET}

# --- configure --------------------------------------------------------

${P_WORKDIR}/.configured: ${P_CONFDEP}
	@mkdir -p ${P_OBJDIR}
	@${ECHO} "port: configuring ${P_NAME}"
.if ${P_BUILDSYS:tl} == "make"
	@${ECHO} "port: ${P_NAME}: no configure step (Makefile only)"
.elif ${P_BUILDSYS:tl} == "cmake"
	cd ${P_OBJDIR} && cmake -G Ninja ${P_BUILDSRC}/${P_CMAKE_SRC} \
		-DCMAKE_INSTALL_PREFIX=${P_PREFIX} \
		-DCMAKE_BUILD_TYPE=Release \
		${P_CONFIGURE_ARGS} > ${P_WORKDIR}/configure.log 2>&1 || \
		{ ${ECHO} "port: ${P_NAME}: configure failed, see ${P_WORKDIR}/configure.log"; \
		  tail -20 ${P_WORKDIR}/configure.log; exit 1; }
.else
	cd ${P_OBJDIR} && ${P_BUILDSRC}/${P_CONFIGURE} \
		--prefix=${P_PREFIX} \
		${_AUTOTOOLS_FLAGS} \
		${P_CONFIGURE_ARGS} > ${P_WORKDIR}/configure.log 2>&1 || \
		{ ${ECHO} "port: ${P_NAME}: configure failed, see ${P_WORKDIR}/configure.log"; \
		  tail -20 ${P_WORKDIR}/configure.log; exit 1; }
.endif
.if defined(P_POST_CONFIGURE)
	@${ECHO} "port: post-configure ${P_NAME}"
	@cd ${P_OBJDIR} && ${P_POST_CONFIGURE}
.endif
	@touch ${.TARGET}

# --- build ------------------------------------------------------------

${P_WORKDIR}/.built: ${P_WORKDIR}/.configured
	@${ECHO} "port: building ${P_NAME}"
	cd ${P_OBJDIR} && ${P_MAKE} ${P_MAKE_ARGS} > ${P_WORKDIR}/build.log 2>&1 || \
		{ ${ECHO} "port: ${P_NAME}: build failed, see ${P_WORKDIR}/build.log"; \
		  tail -20 ${P_WORKDIR}/build.log; exit 1; }
.if defined(P_POST_BUILD)
	@${ECHO} "port: post-build ${P_NAME}"
	@cd ${P_OBJDIR} && ${P_POST_BUILD}
.endif
	@touch ${.TARGET}

# --- stage ------------------------------------------------------------

# DESTDIR goes in the environment for ninja, which would take a
# DESTDIR=... argument for a target name, and as an argument for make.
${P_WORKDIR}/.staged: ${P_WORKDIR}/.built
	@${ECHO} "port: staging ${P_NAME}"
.if ${P_BUILDSYS:tl} == "cmake"
	cd ${P_OBJDIR} && DESTDIR=${P_STAGEDIR} ${P_MAKE} ${P_MAKE_ARGS} install \
		> ${P_WORKDIR}/stage.log 2>&1 || \
		{ ${ECHO} "port: ${P_NAME}: stage failed, see ${P_WORKDIR}/stage.log"; \
		  tail -20 ${P_WORKDIR}/stage.log; exit 1; }
.else
	cd ${P_OBJDIR} && ${P_MAKE} ${P_MAKE_ARGS} install DESTDIR=${P_STAGEDIR} \
		> ${P_WORKDIR}/stage.log 2>&1 || \
		{ ${ECHO} "port: ${P_NAME}: stage failed, see ${P_WORKDIR}/stage.log"; \
		  tail -20 ${P_WORKDIR}/stage.log; exit 1; }
.endif
.if defined(P_POST_STAGE)
	@${ECHO} "port: post-stage ${P_NAME}"
	@cd ${P_BUILDSRC} && ${P_POST_STAGE}
.endif
	@touch ${.TARGET}

# Only this file knows what a port produces -- a port name is not a
# program name -- so the verification lives here.
check:
.for f in ${P_PROGS}
	@test -e ${P_BINDIR}/${f:T} || \
		{ ${ECHO} "MISSING: ${P_BIN}/${f:T}  (port ${P_NAME}, see ${P_WORKDIR}/*.log)"; exit 1; }
.endfor
.for l in ${P_LIBS}
	@test -e ${P_LIBDIR}/${l:T} || \
		{ ${ECHO} "MISSING: ${P_LIBDIR:S|^${RELEASE}/||}/${l:T}  (port ${P_NAME})"; exit 1; }
.endfor
.for src dst in ${P_RELEASE_TREES}
	@test -d ${RELEASE}/${dst} || \
		{ ${ECHO} "MISSING: ${dst}/  (port ${P_NAME})"; exit 1; }
.endfor
.for tgt lnk in ${P_RELEASE_SYMLINK}
	@test -e ${RELEASE}/${lnk} || \
		{ ${ECHO} "MISSING: ${lnk}  (port ${P_NAME})"; exit 1; }
.endfor

clean:
	rm -rf ${P_WORKDIR}
.for f in ${P_PROGS}
	rm -f ${P_BINDIR}/${f:T}
.endfor
.for l in ${P_LIBS}
	rm -f ${P_LIBDIR}/${l:T}
.endfor

.endif

.PHONY: all check clean print-installs
