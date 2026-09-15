/*
 * <LockdownMode/LockdownMode.h> -- the Lockdown Mode class pmset asks.
 *
 * Apple publish no copy of this header.  Class-dumped with ipsw from
 * LockdownMode in macOS 26.5.2's (25F84) dyld shared cache; stock
 * /usr/bin/pmset imports the LockdownModeManager class and sends it
 * +shared and -enabled, as pmset.m does.  Only what the tree uses is
 * declared.
 */
#ifndef _LOCKDOWNMODE_LOCKDOWNMODE_H_
#define _LOCKDOWNMODE_LOCKDOWNMODE_H_

#import <Foundation/Foundation.h>

@interface LockdownModeManager : NSObject
+ (instancetype)shared;
@property (readonly, nonatomic) BOOL enabled;
@end

#endif /* _LOCKDOWNMODE_LOCKDOWNMODE_H_ */
