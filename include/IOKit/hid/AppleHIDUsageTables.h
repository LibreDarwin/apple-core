/*
 * <IOKit/hid/AppleHIDUsageTables.h> -- the Apple vendor HID usage values
 * PowerManagement's ioupsd matches accessory batteries with.
 *
 * Apple publish this header's name but not its tables: IOHIDFamily-2238's
 * copy is only its license comment.  Read from stock /usr/libexec/ioupsd
 * (macOS 26.5.2, 25F84): upsd.m's two parallel matching arrays land in
 * __TEXT,__const as usage pages {0x84, 0x85, 0xff00, 0x84} and usages
 * {0, 0, 0x14, 0x06}.  The source spells them {kIOPowerDeviceUsageKey,
 * kIOBatterySystemUsageKey, kHIDPage_AppleVendor, kHIDPage_PowerDevice} and
 * {0, 0, kHIDUsage_AppleVendor_AccessoryBattery,
 * kHIDUsage_PD_PeripheralDevice}; the public kHIDPage_PowerDevice (0x84)
 * and kHIDUsage_PD_PeripheralDevice (0x06) sit where they should.  Only
 * what the tree uses is declared.
 */
#ifndef _IOKIT_HID_APPLEHIDUSAGETABLES_H
#define _IOKIT_HID_APPLEHIDUSAGETABLES_H

enum {
	kHIDPage_AppleVendor				= 0xff00,
};

enum {
	kHIDUsage_AppleVendor_AccessoryBattery		= 0x14,
};

#endif /* _IOKIT_HID_APPLEHIDUSAGETABLES_H */
