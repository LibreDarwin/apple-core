# bzip2(1) -- and bunzip2 and bzcat, the same binary under the names
# Apple's create_bzip2_links.sh hardlinks.
T_SRCS=		bzip2.c
T_LDADD+=	${LIBDIR}/libbz2.a
T_LINKS=	bunzip2 bzcat
