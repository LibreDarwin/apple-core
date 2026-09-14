# mk/ports.mk - the inventory of components that carry their own build
# system, driven by mk/port.mk.
#
# One entry per port, three whitespace-separated fields:
#
#	PORTS+=	<dir-under-src> <port-name> <install-suffix>
#
#   <dir>             the tree whose configure/CMakeLists/Makefile is
#                     run, under src/ -- often a subdirectory, since
#                     Apple's drops wrap upstream's tree in their own
#   <port-name>       names mk/port.d/<name>.mk and build/ports/<name>
#   <install-suffix>  where its programs go under build/release/
#
# Gated behind MK_PORTS because they are slow: each one runs a full
# configure and make.  See mk/applecore.sys.mk.

.if ${MK_PORTS:tl} == "yes"

.endif # MK_PORTS
