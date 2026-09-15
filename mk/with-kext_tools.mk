# mk/with-kext_tools.mk
#
# Shared fragment: what kext_tools.xcodeproj gives its tools -- MIG type
# checking, ARC for the Objective-C half, the tree's own headers -- and
# what the stock binaries link: CoreFoundation, IOKit (where OSKext lives),
# Foundation, libobjc and libc++.
#
# The private headers they need are in include/: IOKit/kext from
# IOKitUser-100231.120.3, libkern and os/log_private.h from xnu, and
# CoreFoundation/CFBundlePriv.h from CF-1153.18, Security's private
# headers from Security-61901.120.67, and KernelManagementClient as
# class-dumped from the shipped framework.  The sources come from the
# kext_tools patch set (mk/patchsets.mk).
#
#	.include "${TOP}/mk/with-kext_tools.mk"
# kext_tools includes IOKitUser's bootfiles.h by its bare name; it lives in
# include/IOKit/kext, reached after everything else.
#
# Security's private headers mark API unavailable on bridgeos, a platform
# the public SDK's AvailabilityInternal.h has no macros for; these spell
# it the way that file spells watchos.  security.c assigns
# CFDictionaryContainsKey()'s Boolean to a CFBooleanRef (only ever tested
# for zero), which today's clang makes an error.
T_CFLAGS+=	-D__MigTypeCheck=1 -fobjc-arc -I${T_SRCDIR} \
		-idirafter ${TOP}/include/IOKit/kext \
		'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_OBSOLETED_PLATFORM_bridgeos(x,y,z)=bridgeos,introduced=x,deprecated=y,obsoleted=z' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable' \
		-Wno-error=int-conversion
# Xcode dead-strips (DEAD_CODE_STRIPPING), and kext_tools depends on it:
# shared sources reference globals that live only in the kextd target
# (KextdAuthenticationOptions), from functions a given tool never calls.
T_LDADD+=	-framework CoreFoundation -framework IOKit -framework Foundation \
		-lobjc -lc++ -Wl,-dead_strip
