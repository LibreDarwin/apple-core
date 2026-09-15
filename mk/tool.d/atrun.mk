# atrun(8) -- the atrun target of system_cmds.xcodeproj.
#
# It asks BackgroundTaskManagement whether cron-style jobs are enabled,
# behind a feature flag: <btm.h> and the os_feature_enabled() macro in
# <os/feature_private.h> are in include/, recovered from stock atrun and
# the shipped libraries.  Stock atrun links BackgroundTaskManagement alone
# beside libSystem.
# "privs.h" is at(1)'s, in system_cmds/at, which atrun shares.
T_CFLAGS+=	-DDAEMON_UID=1 -DDAEMON_GID=1 -I${TOP}/src/system_cmds/at
T_LDADD+=	-F/System/Library/PrivateFrameworks \
		-framework BackgroundTaskManagement
