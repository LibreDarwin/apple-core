/*
 * <AppleFeatures/AppleFeatures.h> -- apple-core's stand-in for Apple's
 * build-feature header.
 *
 * IOKitUser's <IOKit/ps/IOPowerSourcesPrivate.h> includes it but tests
 * none of its macros, and nothing else in the tree includes it.  Nothing
 * is defined; when a source does test a feature macro, recover its value
 * from the shipped binary and define it here.
 */
#ifndef _APPLEFEATURES_APPLEFEATURES_H_
#define _APPLEFEATURES_APPLEFEATURES_H_

#endif /* _APPLEFEATURES_APPLEFEATURES_H_ */
