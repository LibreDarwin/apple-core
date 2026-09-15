# zlog(1) -- system_cmds' zlog.
#
# It symbolicates zone-logging backtraces through CoreSymbolication, a
# private framework linked through the SDK's stub; its declarations are in
# include/CoreSymbolication (see the header).
T_LDADD+=	-framework CoreFoundation \
		-F/System/Library/PrivateFrameworks -framework CoreSymbolication
