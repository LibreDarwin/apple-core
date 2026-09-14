# ls needs private System/sys/fsctl.h (xnu) + membershipPriv.h (Libinfo) + our libutil.
T_CFLAGS+=	-I${TOP}/include -I${TOP}/include/System -DCOLORLS
.include "${TOP}/mk/with-libutil.mk"
# color support uses terminfo/curses.
T_LDADD+=	-lncurses
