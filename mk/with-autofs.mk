# mk/with-autofs.mk
#
# Shared fragment: what autofs.xcodeproj gives automount and automountd --
# C11 with ARC, the project's shared headers and automountlib -- and what
# the stock binaries link: CoreFoundation, OpenDirectory, SystemConfiguration,
# libutil (for <mntopts.h>, libutil's), and the private ServerInformation,
# libfakelink and oncrpc.
#
# The dispatch private headers automountd uses mark API unavailable on
# bridgeos, which the public SDK has no availability macros for; these
# spell it the way the SDK spells watchos.
#
#	.include "${TOP}/mk/with-autofs.mk"

T_CFLAGS+=	-std=c11 -fobjc-arc -I${TOP}/src/autofs/headers \
		-I${TOP}/src/autofs/mig -I${TOP}/src/autofs/automountlib \
		-I${TOP}/src/libutil \
		'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable'
T_LDADD+=	-framework CoreFoundation -framework OpenDirectory \
		-framework SystemConfiguration \
		-F/System/Library/PrivateFrameworks -framework ServerInformation \
		-framework oncrpc -lfakelink -lutil
