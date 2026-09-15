/*
 * <IOReport.h> -- what PowerManagement's pmset takes from libIOReport.
 *
 * Apple publish no copy of this header.  The functions are the ones stock
 * /usr/bin/pmset (macOS 26.5.2, 25F84) imports and the SDK's
 * libIOReport.tbd exports; argument counts are read from libIOReport in
 * the dyld shared cache (the arguments each keeps or passes on), and types
 * follow what pmset.m hands them and keeps from them.  Channels, samples
 * and channel sets are CF dictionaries; a subscription is opaque.  Stock
 * pmset's iteration blocks return 0 for kIOReportIterOk.  Only what the
 * tree uses is declared.
 */
#ifndef _IOREPORT_H_
#define _IOREPORT_H_

#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOReportTypes.h>
#include <stdint.h>

CF_EXTERN_C_BEGIN

typedef struct IOReportSubscriptionCF *IOReportSubscriptionRef;
typedef CFDictionaryRef IOReportChannelRef;
typedef CFDictionaryRef IOReportSampleRef;

typedef int IOReportIterationResult;
enum {
	kIOReportIterOk		= 0,
};

/* Channel sets and subscriptions. */
CFMutableDictionaryRef IOReportCopyChannelsWithID(CFDictionaryRef matching,
    uint64_t channelID, CFDictionaryRef options);
IOReportIterationResult IOReportMergeChannels(CFMutableDictionaryRef into,
    CFDictionaryRef from, CFTypeRef options);
IOReportSubscriptionRef IOReportCreateSubscription(void *allocator,
    CFMutableDictionaryRef desired, CFMutableDictionaryRef *subscribed,
    uint64_t channelID, CFTypeRef options);

/* Samples. */
CFDictionaryRef IOReportCreateSamples(IOReportSubscriptionRef subscription,
    CFMutableDictionaryRef subscribed, CFTypeRef options);
CFDictionaryRef IOReportCreateSamplesDelta(CFDictionaryRef previous,
    CFDictionaryRef current, CFTypeRef options);
void IOReportIterate(CFDictionaryRef samples,
    IOReportIterationResult (^block)(IOReportSampleRef sample));

/* Channel accessors. */
uint64_t IOReportChannelGetChannelID(IOReportChannelRef channel);
CFStringRef IOReportChannelGetDriverName(IOReportChannelRef channel);
int64_t IOReportSimpleGetIntegerValue(IOReportChannelRef channel,
    int32_t *error);
int64_t IOReportArrayGetValueAtIndex(IOReportChannelRef channel, int index);
int IOReportStateGetCount(IOReportChannelRef channel);
int IOReportStateGetCurrent(IOReportChannelRef channel);
uint64_t IOReportStateGetIDForIndex(IOReportChannelRef channel, int index);
int64_t IOReportStateGetInTransitions(IOReportChannelRef channel, int index);
int64_t IOReportStateGetResidency(IOReportChannelRef channel, int index);

CF_EXTERN_C_END

#endif /* _IOREPORT_H_ */
