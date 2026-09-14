# apple-core -- top-level Makefile (BSD bmake).
#
#	./configure?  No.  Just:  bmake
#
# Targets:
#	all		build every library, port and program into build/
#	check		verify every inventory entry produced what it
#			installs, and that nothing no longer in the
#			inventory is left in the release tree
#	check-stale	only the second half of check
#	clean		remove build/, keeping the ports work directories
#	clean-ports	remove the ports work directories
#	distclean	remove build/ entirely
#	list-progs	print the program inventory with release placements
#	list-libs	print the library inventory
#	list-ports	print the port inventory
#
# The release tree lands in build/release/, laid out as the root of a
# stock macOS install -- bin, sbin, usr/bin, usr/sbin, usr/libexec,
# usr/lib -- with each file where macOS keeps its own copy.

TOP?=		${.CURDIR}

.include "${TOP}/mk/applecore.sys.mk"

# lib before everything: the programs link its archives.
all: dirs lib ports progs
	@${ECHO} "== apple-core build complete =="
	@${ECHO} "   release tree: ${RELEASE}"
	@${ECHO} "   per-entry failures do not stop the build: run bmake check"

dirs:
.for d in bin sbin usr/bin usr/sbin usr/libexec usr/lib
	@mkdir -p ${RELEASE}/${d}
.endfor

lib:
	${MAKE} -C ${TOP}/lib TOP=${TOP}

ports:
	${MAKE} -C ${TOP}/ports TOP=${TOP}

progs:
	${MAKE} -C ${TOP}/src TOP=${TOP}

check:
	@s=0; \
	${MAKE} -C ${TOP}/lib TOP=${TOP} check-libs || s=1; \
	${MAKE} -C ${TOP}/ports TOP=${TOP} check-ports || s=1; \
	${MAKE} -C ${TOP}/src TOP=${TOP} check-progs || s=1; \
	${MAKE} -C ${TOP} TOP=${TOP} check-stale || s=1; \
	exit $$s

# The other half of check: files in the release tree that nothing in mk/
# installs any more.  build/release is only ever added to, so taking an
# entry out of the inventory leaves its last build behind.  The claimed
# names are collected with every tier switched on, so building without a
# tier does not make its files look stale.
# ponytail: install directories only, one level deep; man pages and
# other trees a port stages are not swept.
STALE_DIRS=	bin sbin usr/bin usr/sbin usr/libexec usr/lib \
		usr/local/bin usr/local/lib
ALL_TIERS=	MK_DIAGNOSTICS=yes MK_DAEMONS=yes MK_PRIVATE_FRAMEWORKS=yes \
		MK_PORTS=yes

check-stale:
	@t=$$(mktemp -d) && trap 'rm -rf "$$t"' EXIT && \
	{ ${MAKE} -C ${TOP}/lib TOP=${TOP} print-installs && \
	  ${MAKE} -C ${TOP}/src TOP=${TOP} ${ALL_TIERS} print-installs && \
	  ${MAKE} -C ${TOP}/ports TOP=${TOP} ${ALL_TIERS} print-installs; } \
	    | sort -u > "$$t/claimed" && \
	( cd ${RELEASE} && for d in ${STALE_DIRS}; do \
	    [ -d "$$d" ] && find "$$d" -maxdepth 1 -mindepth 1 \( -type f -o -type l \); \
	  done ) | sort > "$$t/installed" && \
	comm -23 "$$t/installed" "$$t/claimed" > "$$t/stale" && \
	if [ -s "$$t/stale" ]; then \
		sed 's/^/STALE: /' "$$t/stale"; \
		echo "check: installed by nothing in mk/ -- remove them from the release tree"; \
		exit 1; \
	fi && echo "check: nothing stale in the release tree"

list-progs:
	@${MAKE} -C ${TOP}/src TOP=${TOP} list-progs

list-libs:
	@${MAKE} -C ${TOP}/lib TOP=${TOP} list-libs

list-ports:
	@${MAKE} -C ${TOP}/ports TOP=${TOP} list-ports

# clean spares build/ports: a port's configure and build is the slow
# part of the tree, and throwing it away is not what an ordinary rebuild
# means.  clean-ports does that, and distclean does everything.
clean:
	find ${TOP}/build -mindepth 1 -maxdepth 1 ! -name ports -exec rm -rf {} + 2>/dev/null || true

clean-ports:
	rm -rf ${TOP}/build/ports

distclean: clean clean-ports
	rm -rf ${TOP}/build

.PHONY: all dirs lib ports progs check check-stale list-progs list-libs \
	list-ports clean clean-ports distclean
