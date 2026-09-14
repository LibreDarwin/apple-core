# setkey(8) -- the setkey target: its grammar and scanner, three of the
# Common sources, and libipsec.  token.l includes the grammar's header as
# y.tab.h, the name yacc gives it; mk/tool.mk calls it parse.tab.h, so a
# copy is made under the old name.  var.h is racoon's, reached with
# -idirafter so racoon's other headers cannot shadow the system's.
# PRIVATE exposes the PF_KEY extensions (sadb_x_ipsecif and friends) in
# include/net/pfkeyv2.h, xnu's copy of the header the SDK ships trimmed.
T_SRCS=	parse.y src/ipsec/ipsec-tools/Common/pfkey_dump.c \
		src/ipsec/ipsec-tools/Common/key_debug.c \
		src/ipsec/ipsec-tools/Common/pfkey.c setkey.c token.l
T_CFLAGS+=	-DHAVE_CONFIG_H=1 -DPRIVATE -I${TOP}/src/ipsec/ipsec-tools/Common \
		-idirafter ${TOP}/src/ipsec/ipsec-tools/racoon \
		-I${TOP}/src/ipsec/ipsec-tools/libipsec -I${T_SRCDIR} -I${T_OBJDIR}
T_LDADD+=	${LIBDIR}/libipsec.a

${T_OBJDIR}/y.tab.h: ${T_OBJDIR}/parse.tab.h
	cp ${T_OBJDIR}/parse.tab.h ${.TARGET}

${T_OBJDIR}/token.l.lex.o: ${T_OBJDIR}/y.tab.h
