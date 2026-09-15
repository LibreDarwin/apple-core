# od_user_homes(8) -- the od_user_homes target of autofs.xcodeproj, the
# automount map program for users' network home directories.
T_SRCS=		src/autofs/od_user_homes/od_user_homes.c
T_CFLAGS+=	-std=c11 -fobjc-arc
T_LDADD+=	-framework CoreFoundation -framework OpenDirectory
