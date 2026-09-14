# libipsec -- installed as /usr/lib/libipsec.A.dylib, with the libipsec.dylib
# link Apple's install phase makes.  Its grammar and scanner take the
# __libipsec symbol prefix Apple's YACCFLAGS and LEXFLAGS give them, so
# they do not collide with setkey's own; policy_token.l includes the
# grammar's header as y.tab.h.  var.h is racoon's, reached with -idirafter
# so racoon's other headers cannot shadow the system's.
T_SRCS=	ipsec_dump_policy.c ipsec_get_policylen.c ipsec_strerror.c \
		policy_parse.y policy_token.l
T_YFLAGS=	-p__libipsec
T_LFLAGS=	-P__libipsec
T_CFLAGS+=	-DHAVE_CONFIG_H=1 -I${TOP}/src/ipsec/ipsec-tools/Common \
		-idirafter ${TOP}/src/ipsec/ipsec-tools/racoon \
		-I${T_SRCDIR} -I${T_OBJDIR}
T_DYLIB=	libipsec.A.dylib
T_LINKS=	libipsec.dylib

${T_OBJDIR}/y.tab.h: ${T_OBJDIR}/policy_parse.tab.h
	cp ${T_OBJDIR}/policy_parse.tab.h ${.TARGET}

${T_OBJDIR}/policy_token.l.lex.o: ${T_OBJDIR}/y.tab.h
