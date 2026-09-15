# kextload(8) -- the kextload target of kext_tools.xcodeproj.
#
# BLOCKED: its sources include headers of frameworks Apple publish neither
# source nor headers for -- <SystemPolicy/SystemPolicy.h> (syspolicy.m) and
# <MultiverseSupport/kext_audit_plugin_common.h> (kextaudit.c) -- and two
# private headers in no published release: <CoreFoundation/CFXPCBridge.h>
# (driverkit.m) and <os/cleanup.h> (staging.m).
T_NOBUILD=	yes
