# libxo (lib/libxo) -- built outside its autotools.  xo_config.h comes
# from our hand-maintained Darwin configuration, mk/xo_config.darwin.h,
# generated into build/gen/libxo ahead of every object.
T_SRCS=		libxo.c xo_encoder.c xo_format.c xo_syslog.c \
		xo_tolower.c xo_toupper.c xo_utf8.c

XO_GEN=		${TOP}/build/gen/libxo
T_CFLAGS+=	-I${XO_GEN} -I${T_SRCDIR}

${XO_GEN}/xo_config.h: ${TOP}/mk/xo_config.darwin.h
	@mkdir -p ${.TARGET:H}
	cp ${TOP}/mk/xo_config.darwin.h ${.TARGET}

.for s in ${T_SRCS}
${T_OBJDIR}/${s:R}.o: ${XO_GEN}/xo_config.h
.endfor
