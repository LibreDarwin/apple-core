# mk/with-libtelnet.mk
#
# Link a tool against our crypto-free libtelnet (option-negotiation
# helpers).  -I src resolves the <libtelnet/*.h> includes.
T_CFLAGS+=	-I${TOP}/src
T_LDADD+=	${LIBDIR}/libtelnet.a
