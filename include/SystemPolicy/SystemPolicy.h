/*
 * <SystemPolicy/SystemPolicy.h> -- the kernel-extension policy class
 * kext_tools' syspolicy.m uses.
 *
 * Apple publish no copy of this header.  Class-dumped with ipsw from
 * SystemPolicy in macOS 26.5.2's (25F84) dyld shared cache; the SDK's
 * SystemPolicy.tbd lists SPKernelExtensionPolicy among its classes.  Only
 * the methods the tree calls are declared.
 */
#ifndef _SYSTEMPOLICY_SYSTEMPOLICY_H_
#define _SYSTEMPOLICY_SYSTEMPOLICY_H_

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPKernelExtensionPolicy : NSObject
- (instancetype)init;
- (BOOL)canLoadKernelExtension:(NSString *)path
                         error:(NSError * _Nullable * _Nullable)error;
- (BOOL)canLoadKernelExtensionInCache:(NSString *)path
                                error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END

#endif /* _SYSTEMPOLICY_SYSTEMPOLICY_H_ */
