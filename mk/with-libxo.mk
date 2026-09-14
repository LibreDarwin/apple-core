# mk/with-libxo.mk
#
# Shared fragment: include from a tool's mk/tool.d/<prog>.mk to build
# against the lib/libxo static library (Apple-flavored structured
# output: text, XML, JSON, HTML via xo_emit/xo_parse_args).
#
#	T_CFLAGS+= -I${TOP}/lib/libxo/libxo
#	T_LDADD+=  ${LIBDIR}/libxo.a

T_CFLAGS+=	-I${TOP}/lib/libxo/libxo
T_LDADD+=	${LIBDIR}/libxo.a
