# mk/with-libfsck_hfs.mk
#
# Link a tool against fsck_hfs' support library (built from the hfs submodule
# by lib/Makefile).
#
# -DBSD selects dfalib's modern code path.  SRuntime.h keys on `#if BSD`:
# with it, dfalib uses <hfs/hfs_format.h> and its own type/error definitions;
# without it, it falls back to the classic Carbon headers (MacTypes.h,
# MacMemory.h, HFSVolumes.h, Errors.h), which Apple no longer ships.
# DEBUG_BUILD=0 selects release semantics: dfalib gates debug-only Panic()
# assertions behind `if (DEBUG_BUILD && ...)`.
T_CFLAGS+=	-DBSD=1 -DDEBUG_BUILD=0 \
		-I${TOP}/src/hfs/lib_fsck_hfs -I${TOP}/src/hfs/lib_fsck_hfs/dfalib
T_LDADD+=	${LIBDIR}/libfsck_hfs.a
