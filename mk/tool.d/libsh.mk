# libsh -- bash's portability library: the libsh target of bash.xcodeproj,
# static and only for bash(1).
T_SRCS=	eaccess.c fmtulong.c fmtumax.c getenv.c itos.c mailstat.c \
		makepath.c netconn.c netopen.c oslib.c pathcanon.c \
		pathphys.c setlinebuf.c shmatch.c shquote.c shtty.c \
		spell.c strindex.c stringlist.c stringvec.c strnlen.c \
		strtoimax.c strtoumax.c strtrans.c timeval.c tmpfile.c \
		wcsdup.c winsize.c xstrchr.c zcatfd.c zread.c zwrite.c

.include "${TOP}/mk/with-bash.mk"
