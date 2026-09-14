# libtelnet -- only the crypto-free support pieces (option negotiation
# helpers).  The auth/encrypt sources need krb5/DES and are pulled in
# solely under -DAUTHENTICATION/-DENCRYPTION, which our telnet does not
# set.
T_SRCS=		misc.c genget.c getent.c
T_CFLAGS+=	-I${T_SRCDIR}
