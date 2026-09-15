/*
 * <os/feature_private.h> -- the feature-flags SPI (libsystem_featureflags).
 *
 * Apple publish no copy of this header.  kext_tools' security.c includes it
 * and calls nothing from it; system_cmds' atrun calls
 * os_feature_enabled(cronBTMToggle, cronBTMCheck).  Stock /usr/libexec/atrun
 * (macOS 26.5.2, 25F84) compiles that to _os_feature_enabled_impl("cronBTMToggle",
 * "cronBTMCheck") -- the two tokens as C strings -- and tests the result as
 * a boolean; libsystem_featureflags' stub exports it.  Only what the tree
 * uses is declared.
 */
#ifndef __OS_FEATURE_PRIVATE__
#define __OS_FEATURE_PRIVATE__

#include <sys/cdefs.h>
#include <stdbool.h>

__BEGIN_DECLS

bool _os_feature_enabled_impl(const char *domain, const char *feature);

#define os_feature_enabled(domain, feature) \
	_os_feature_enabled_impl(#domain, #feature)

__END_DECLS

#endif /* __OS_FEATURE_PRIVATE__ */
