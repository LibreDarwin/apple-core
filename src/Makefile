# src/Makefile
#
# Drives the build of every program listed in mk/progs.mk by recursing
# into mk/tool.mk once per entry.  The three fields of each entry map
# round-robin onto d (source dir), p (program name) and b (release
# suffix).

TOP?=		${.CURDIR}/..

.include "${TOP}/mk/applecore.sys.mk"
.include "${TOP}/mk/progs.mk"

_ENTRIES=
.for d p b in ${PROGS}
. if empty(DISABLED_PROGS:M${p})
_ENTRIES+=	${d}:${p}:${b}
. endif
.endfor

_EACH=		for e in ${_ENTRIES}; do \
		    set -- $$(echo "$$e" | tr : ' '); \
		    ${MAKE} -f ${TOP}/mk/tool.mk TOP=${TOP} \
			T_DIR=$$1 T_PROG=$$2 T_BIN=$$3

# One tool failing to build does not stop the rest -- which also means a
# broken tool silently vanishes from the release tree.  check-progs is
# the guard.
all:
	@${_EACH} || true; done

clean:
	@${_EACH} clean || true; done

check-progs:
	@s=0; ${_EACH} check || s=1; done; \
	[ $$s = 0 ] && ${ECHO} "check: every program entry produced its binary" || exit 1

print-installs:
	@${_EACH} print-installs; done

list-progs:
.for d p b in ${PROGS}
. if empty(DISABLED_PROGS:M${p})
	@${ECHO} "${b}/${p}	<- src/${d}"
. endif
.endfor

.PHONY: all clean check-progs list-progs print-installs
