# caffeinate(8) -- the caffeinate target of PowerManagement.xcodeproj.
#
# It takes its assertion names from <IOKit/pwr_mgt/IOPMLibPrivate.h>, which
# include/ carries with IOPMAssertionCategories.h from IOKitUser-100231.120.3.
T_SRCS=		src/PowerManagement/caffeinate/caffeinate.c
T_LDADD+=	-framework CoreFoundation -framework IOKit
