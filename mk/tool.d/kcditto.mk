# kcditto(8) -- the kcditto target of kext_tools.xcodeproj.
#
# BLOCKED: it needs <Bom/Bom.h>, <EFILogin/EFILogin.h> and the CoreStorage
# headers under <IOKit/storage/CoreStorage/>, none of which Apple publish.
T_NOBUILD=	yes
