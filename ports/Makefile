# ports/Makefile
#
# Drives every entry of mk/ports.mk by recursing into mk/port.mk once
# per port, the same way src/Makefile drives mk/tool.mk.

TOP?=		${.CURDIR}/..

.include "${TOP}/mk/applecore.sys.mk"
.include "${TOP}/mk/ports.mk"

# Ports are opt-in: mk/ports.mk defines PORTS only under MK_PORTS=yes, so
# without it every loop below iterates over nothing -- and check-ports
# would announce that every port produced its files having looked at
# none of them.  Say what happened instead.
.if ${MK_PORTS:tl} != "yes"

PORTS_OFF=	ports: disabled (MK_PORTS=no).  Enable with: bmake MK_PORTS=yes

all clean list-ports:
	@${ECHO} "${PORTS_OFF}"

check-ports:
	@${ECHO} "${PORTS_OFF}"
	@${ECHO} "check: no ports checked"

print-installs:

.else

_ENTRIES=
.for d p b in ${PORTS}
. if empty(DISABLED_PROGS:M${p})
_ENTRIES+=	${d}:${p}:${b}
. endif
.endfor

_EACH=		for e in ${_ENTRIES}; do \
		    set -- $$(echo "$$e" | tr : ' '); \
		    ${MAKE} -f ${TOP}/mk/port.mk TOP=${TOP} \
			P_DIR=$$1 P_NAME=$$2 P_BIN=$$3

# As in src/Makefile, one port failing does not stop the rest -- and
# ports are the likeliest thing to fail, since each drives a foreign
# build system.  check-ports is the guard.
all:
	@${_EACH} || true; done

clean:
	@${_EACH} clean || true; done

check-ports:
	@s=0; ${_EACH} check || s=1; done; \
	[ $$s = 0 ] && ${ECHO} "check: every port produced its files" || exit 1

print-installs:
	@${_EACH} print-installs; done

list-ports:
.for d p b in ${PORTS}
	@${ECHO} "${b}/${p}	<- src/${d}"
.endfor

.endif

.PHONY: all clean check-ports list-ports print-installs
