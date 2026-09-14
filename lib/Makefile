# lib/Makefile
#
# Drives the build of every library listed in mk/libs.mk by recursing
# into mk/tool.mk once per entry, the same way src/Makefile drives the
# programs.  Runs before the programs, which link these archives.
#
# The sources are submodules under src/ (libutil, libmd, libtelnet, ...)
# or, for libxo, under lib/ -- see mk/libs.mk.

TOP?=		${.CURDIR}/..

.include "${TOP}/mk/applecore.sys.mk"
.include "${TOP}/mk/libs.mk"

_ENTRIES=
.for d n b in ${LIBS}
_ENTRIES+=	${d}:${n}:${b}
.endfor

_EACH=		for e in ${_ENTRIES}; do \
		    set -- $$(echo "$$e" | tr : ' '); \
		    ${MAKE} -f ${TOP}/mk/tool.mk TOP=${TOP} T_KIND=lib \
			T_DIR=$$1 T_PROG=$$2 T_BIN=$$3

# As in src/Makefile, a failure does not stop the rest; check-libs is
# the guard.  A missing archive shows up again as link failures in the
# programs that need it.
all:
	@${_EACH} || true; done

clean:
	@${_EACH} clean || true; done

check-libs:
	@s=0; ${_EACH} check || s=1; done; \
	[ $$s = 0 ] && ${ECHO} "check: every library entry produced its files" || exit 1

print-installs:
	@${_EACH} print-installs; done

# The dylib's name comes from the entry's fragment (T_DYLIB), so ask
# mk/tool.mk rather than guessing it here.
list-libs:
	@for e in ${_ENTRIES}; do \
	    set -- $$(echo "$$e" | tr : ' '); \
	    i=$$(${MAKE} -f ${TOP}/mk/tool.mk TOP=${TOP} T_KIND=lib \
		T_DIR=$$1 T_PROG=$$2 T_BIN=$$3 print-installs | head -1); \
	    ${ECHO} "build/lib/$$2.a$${i:+ + $$i}	<- src/$$1"; \
	done

.PHONY: all clean check-libs list-libs print-installs
