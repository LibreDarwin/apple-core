# libglob -- bash's globbing and pattern matching: the glob target of bash.xcodeproj,
# static and only for bash(1).
T_SRCS=	glob.c smatch.c strmatch.c xmbsrtowcs.c

.include "${TOP}/mk/with-bash.mk"
