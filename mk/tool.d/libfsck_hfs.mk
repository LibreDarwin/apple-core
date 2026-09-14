# libfsck_hfs -- fsck_hfs' support library.  Sources are discovered so
# the dfalib set tracks upstream; DecompMakeData is excluded, being a
# build-time generator with its own main() rather than library code.
#
# -DBSD=1 is what keeps the classic Carbon headers (<Errors.h> and
# friends) out: they sit in the #else of `#if BSD'.
_LFH=		src/hfs/lib_fsck_hfs
T_SRCS!=	cd ${TOP}/${_LFH} && ls *.c dfalib/*.c | grep -v DecompMakeData | \
		    sed 's|^|${_LFH}/|'
T_CFLAGS+=	-DBSD=1 -DDEBUG_BUILD=0 -I${TOP}/${_LFH} -I${TOP}/${_LFH}/dfalib \
		-I${TOP}/src/hfs/fsck_hfs
