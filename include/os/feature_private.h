/*
 * <os/feature_private.h> -- apple-core's stand-in for the feature-flags
 * SPI (libsystem_featureflags).
 *
 * kext_tools' security.c includes it but calls nothing from it, and the
 * stock kextload and kextutil built from that file import no feature-flag
 * symbol.  Nothing is declared; when a source does call os_feature_enabled(),
 * recover _os_feature_enabled_impl() from libsystem_featureflags with ipsw
 * and declare it here.
 */
#ifndef __OS_FEATURE_PRIVATE__
#define __OS_FEATURE_PRIVATE__

#endif /* __OS_FEATURE_PRIVATE__ */
