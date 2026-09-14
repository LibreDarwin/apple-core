# bash(1) -- Apple's bash 3.2, the bash target of bash.xcodeproj, linked
# as that target links it: against builtins, readline, libsh, glob and
# intl (mk/libs.mk) and the system ncurses.  The builtins are an archive
# of their own here, as in bash's own Makefile, because builtins/alias.c
# and alias.c -- and eval, jobs, test and trap likewise -- would otherwise
# share an object name.
#
# print_cmd.c and execute_cmd.c include the grammar's header as y.tab.h,
# the name yacc gives it; mk/tool.mk calls it parse.tab.h, so a copy is
# made under the old name.
T_SRCS=	src/bash/syntax.c shell.c general.c siglist.c alias.c array.c \
		arrayfunc.c bashhist.c bashline.c bracecomp.c braces.c \
		copy_cmd.c dispose_cmd.c error.c eval.c execute_cmd.c \
		expr.c findcmd.c flags.c hashcmd.c hashlib.c input.c \
		jobs.c list.c locale.c mailcheck.c make_cmd.c parse.y \
		pathexp.c pcomplete.c pcomplib.c print_cmd.c redir.c \
		sig.c stringlib.c subst.c test.c trap.c unwind_prot.c \
		variables.c version.c xmalloc.c
T_CFLAGS+=	-I${T_OBJDIR}
T_LDADD+=	${LIBDIR}/libbuiltins.a ${LIBDIR}/libreadline.a \
		${LIBDIR}/libsh.a ${LIBDIR}/libglob.a ${LIBDIR}/libintl.a \
		-lncurses

${T_OBJDIR}/y.tab.h: ${T_OBJDIR}/parse.tab.h
	cp ${T_OBJDIR}/parse.tab.h ${.TARGET}

${T_OBJDIR}/print_cmd.o ${T_OBJDIR}/execute_cmd.o: ${T_OBJDIR}/y.tab.h

.include "${TOP}/mk/with-bash.mk"
