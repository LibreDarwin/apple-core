# smbremountserver -- the smbremountserver target of autofs.xcodeproj, one
# of the helper tools autofs.kext carries in its Resources.
#
# It calls SMBRemountServer(), declared in SMBClient's smbclient_internal.h;
# include/SMBClient carries smbclient.h and smbclient_internal.h from
# SMBClient-538.121.1.  SMBClient itself is a private framework, linked
# through the SDK's stub.
T_SRCS=		src/autofs/smbremountserver/smbremountserver.c
T_CFLAGS+=	-std=c11
T_LDADD+=	-framework CoreFoundation \
		-F/System/Library/PrivateFrameworks -framework SMBClient
