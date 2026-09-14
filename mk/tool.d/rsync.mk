# rsync(1) -- Apple's openrsync, the openrsync target of rsync.xcodeproj,
# installed as rsync as the target names it.  config.h is Apple's, at the
# top of the submodule; openrsync carries its own zlib.  Apple links
# libutil and libsbuf, whose sbuf(9) our libutil carries (mk/patches).
T_SRCS=	platform.c blocks.c client.c compats.c daemon_misc.c batch.c \
		daemon.c copy.c downloader.c fmap.c \
		src/rsync/openrsync/zlib/adler32.c fargs.c flist.c \
		daemon_cfg.c src/rsync/openrsync/zlib/inflate.c \
		src/rsync/openrsync/zlib/crc32.c strmode.c hardlinks.c \
		hash.c ids.c io.c log.c \
		src/rsync/openrsync/zlib/deflate.c \
		src/rsync/openrsync/zlib/inftrees.c main.c misc.c \
		mkpath.c src/rsync/openrsync/zlib/compress.c mktemp.c \
		src/rsync/openrsync/zlib/inffast.c \
		src/rsync/openrsync/zlib/zutil.c receiver.c rmatch.c \
		rules.c sender.c server.c session.c cleanup.c socket.c \
		symlinks.c uploader.c src/rsync/openrsync/zlib/trees.c \
		src/rsync/password_enabled.c
# The search paths are Apple's -- rsync and rsync/popt, beside config.h --
# plus libmd for <md4.h>.  openrsync's own md4.h includes <md4.h> expecting
# libmd's, so its directory must not be on the angle-bracket path, where it
# would find itself.
T_CFLAGS+=	-std=gnu99 -DHAVE_CONFIG_H=1 -I${TOP}/src/rsync \
		-I${TOP}/src/rsync/rsync -I${TOP}/src/rsync/rsync/popt \
		-I${TOP}/src/libmd/libmd
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-lresolv
