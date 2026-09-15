# mk/patchsets.mk -- entries that share one patch set, and with it one
# private patched copy of their submodule.  Read by mk/tool.mk before an
# entry's fragment; T_DIR and T_PROG are set.  Unlisted entries use the
# patch set named after themselves.

# Every kext_tools program compiles the same shared sources.
.if ${T_DIR} == "kext_tools" || !empty(T_DIR:Mkext_tools/*)
T_PATCHSET=	kext_tools
.endif
