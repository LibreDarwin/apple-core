# kextcache(8) -- the kextcache target of kext_tools.xcodeproj.
#
# BLOCKED: beyond kextload's blockers (SystemPolicy, CFXPCBridge.h,
# os/cleanup.h) it needs <Bom/Bom.h>, <EFILogin/EFILogin.h> and the
# CoreStorage headers under <IOKit/storage/CoreStorage/>, none of which
# Apple publish.
T_NOBUILD=	yes
