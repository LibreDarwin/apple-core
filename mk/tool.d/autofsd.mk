# autofsd(8) -- the autofsd target of autofs.xcodeproj, which watches
# OpenDirectory for automount map changes.
#
# The OpenDirectory trigger API it uses is declared in
# include/OpenDirectory/OpenDirectoryPriv.h, recovered from CFOpenDirectory.
# Stock autofsd links IOKit, CoreFoundation, OpenDirectory and the private
# oncrpc framework.
T_SRCS=		src/autofs/autofsd/autofsd.c
T_CFLAGS+=	-std=c11 -fobjc-arc
T_LDADD+=	-framework IOKit -framework CoreFoundation \
		-framework OpenDirectory \
		-F/System/Library/PrivateFrameworks -framework oncrpc
