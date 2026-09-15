# automountd(8) -- the automountd target of autofs.xcodeproj.
#
# Its private headers are automount's (see automount.mk), plus
# libdispatch-1542.0.4's private headers for the dispatch_mach channel
# API, in include/dispatch.  autofs_prot.defs is built with MIG as the
# server side automountd answers.  Stock automountd links libbsm beside
# what automount links.
AM_GEN=		${TOP}/build/gen/automountd
T_SRCS=	src/autofs/automountlib/auto_subr.c \
		src/autofs/automountlib/sysctl_fsid.c \
		src/autofs/automountlib/we_are_a_server.c \
		src/autofs/automountlib/deflt.c \
		src/autofs/automountlib/ns_files.c \
		src/autofs/automountlib/ns_od.c \
		src/autofs/automountlib/selfcheck.c \
		src/autofs/automountlib/ns_generic.c \
		src/autofs/automountlib/umount_by_fsid.c \
		src/autofs/automountlib/host_is_us.c \
		src/autofs/automountlib/ns_fstab.c \
		src/autofs/automountd/mount_xdr.c \
		src/autofs/automountd/autod_mount.c \
		src/autofs/automountd/autod_lookup.c \
		src/autofs/automountd/autod_autofs.c \
		src/autofs/automountd/autod_nfs.c \
		src/autofs/automountd/autod_parse.c \
		src/autofs/automountd/nfs_cast.c \
		src/autofs/automountd/nfs_subr.c \
		src/autofs/automountd/replica.c \
		src/autofs/automountd/autod_main.c \
		src/autofs/automountd/autod_readdir.c \
		build/gen/automountd/autofs_protServer.c
.include "${TOP}/mk/with-autofs.mk"
T_CFLAGS+=	-I${AM_GEN} -I${TOP}/src/autofs/automountd
T_LDADD+=	-lbsm

${AM_GEN}/autofs_protServer.h ${AM_GEN}/autofs_protServer.c: \
    ${TOP}/src/autofs/mig/autofs_prot.defs
	@mkdir -p ${AM_GEN}
	cd ${AM_GEN} && ${MIG} -I${TOP}/src/autofs/mig -I${TOP}/src/autofs/headers \
	    -header /dev/null -user /dev/null \
	    -sheader autofs_protServer.h -server autofs_protServer.c \
	    ${TOP}/src/autofs/mig/autofs_prot.defs

.for s in ${T_SRCS:N*/gen/*}
${T_OBJDIR}/${s:T:R}.o: ${AM_GEN}/autofs_protServer.h
.endfor
