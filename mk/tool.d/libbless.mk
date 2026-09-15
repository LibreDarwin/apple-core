# libbless -- the libbless target of bless.xcodeproj, a static library
# kextutil, kextcache and kcditto link, as Apple's do.
#
# The target builds with libbless/ on the header path and bless-prefix.h
# as its prefix header.  The APFS pieces it needs beyond the staged APFS
# framework headers -- the snapshot-lookup and boot-info fsctls, the IOKit
# media class and the enumerated volume roles -- are recovered from stock
# /usr/sbin/bless into include/apfs/apfs_fsctl.h and APFSConstants.h.
#
# HFS/BLSetOFLabelForDevice.c is left out: it is the one file needing
# MediaKit, a private framework with no published headers, and nothing in
# the tree calls BLSetOFLabelForDevice().
T_SRCS=	src/bless/libbless/FinderInfo/BLDumpVolumeFinderInfo.c \
		src/bless/libbless/FinderInfo/BLGetFinderFlag.c \
		src/bless/libbless/FinderInfo/BLGetVolumeFinderInfo.c \
		src/bless/libbless/FinderInfo/BLSetFinderFlag.c \
		src/bless/libbless/FinderInfo/BLSetTypeAndCreator.c \
		src/bless/libbless/FinderInfo/BLSetVolumeFinderInfo.c \
		src/bless/libbless/HFS/BLBlessDir.c \
		src/bless/libbless/HFS/BLGetFileID.c \
		src/bless/libbless/HFS/BLIsMountHFS.c \
		src/bless/libbless/HFS/BLLookupFileIDOnMount.c \
		src/bless/libbless/HFS/BLWriteStartupFile.c \
		src/bless/libbless/Misc/BLGetCommonMountPoint.c \
		src/bless/libbless/Misc/BLGetParentDevice.c \
		src/bless/libbless/Misc/BLIsNewWorld.c \
		src/bless/libbless/OpenFirmware/BLGetOpenFirmwareBootDevice.c \
		src/bless/libbless/APFS/BLHandleAPFSBlessData.c \
		src/bless/libbless/OpenFirmware/BLGetOpenFirmwareBootDeviceForMountPoint.c \
		src/bless/libbless/OpenFirmware/BLSetOpenFirmwareBootDevice.c \
		src/bless/libbless/OpenFirmware/BLSetOpenFirmwareBootDeviceForMountPoint.c \
		src/bless/libbless/OpenFirmware/BLGetDeviceForOpenFirmwarePath.c \
		src/bless/libbless/Misc/BLCopyFileFromCFData.c \
		src/bless/libbless/Misc/BLGenerateOFLabel.c \
		src/bless/libbless/Misc/BLBlockChecksum.c \
		src/bless/libbless/Misc/BLContextPrint.c \
		src/bless/libbless/Misc/BLLoadFile.c \
		src/bless/libbless/Misc/BLCreateFile.c \
		src/bless/libbless/HFS/BLGetDiskSectorsForFile.c \
		src/bless/libbless/Misc/BLMiscUtilities.c \
		src/bless/libbless/OpenFirmware/BLIsOpenFirmwarePresent.c \
		src/bless/libbless/RAID/BLGetRAIDBootDataForDevice.c \
		src/bless/libbless/RAID/BLUpdateRAIDBooters.c \
		src/bless/libbless/HFS/BLUpdateBooter.c \
		src/bless/libbless/OpenFirmware/BLDeviceNeedsBooter.c \
		src/bless/libbless/Misc/BLGetIOServiceForDeviceName.c \
		src/bless/libbless/Misc/BLGetPreBootEnvironmentType.c \
		src/bless/libbless/EFI/BLCreateEFIXMLRepresentationForPath.c \
		sharedUtilities.c \
		src/bless/libbless/Network/BLGetPreferredNetworkInterface.c \
		src/bless/libbless/Network/BLIsValidNetworkInterface.c \
		src/bless/libbless/EFI/BLCreateEFIXMLRepresentationForNetworkPath.c \
		src/bless/libbless/APFS/BLIsMountAPFS.c \
		src/bless/libbless/Misc/BLPreserveBootArgs.c \
		src/bless/libbless/EFI/BLCreateEFIXMLRepresentationForDevice.c \
		src/bless/libbless/EFI/BLInterpretEFIXMLRepresentationAsNetworkPath.c \
		src/bless/libbless/EFI/BLCopyEFINVRAMVariableAsString.c \
		src/bless/libbless/EFI/BLInterpretEFIXMLRepresentationAsDevice.c \
		src/bless/libbless/EFI/BLCreateEFIXMLRepresentationForLegacyDevice.c \
		src/bless/libbless/EFI/BLValidateXMLBootOption.c \
		src/bless/libbless/EFI/BLInterpretEFIXMLRepresentationAsLegacyDevice.c \
		src/bless/libbless/EFI/BLSupportsLegacyMode.c \
		src/bless/libbless/APFS/BLIsMountAPFSSSV.c \
		src/bless/libbless/OpenFirmware/BLGetOpenFirmwareBootDeviceForNetworkPath.c \
		src/bless/libbless/APFS/BLGetAPFSInodeNum.c \
		src/bless/libbless/Misc/BLCreateBooterInformationDictionary.c \
		src/bless/libbless/Misc/BLGetCStringRepresentation.c \
		src/bless/libbless/EFI/BLIsEFIRecoveryAccessibleDevice.c \
		src/bless/libbless/OpenFirmware/BLCopyOpenFirmwareNVRAMVariableAsString.c \
		src/bless/libbless/BootRoot/BLBootRootIdentifyDevice.c \
		src/bless/libbless/BootRoot/BLBootRootMapDeviceToMembers.c \
		src/bless/libbless/APFS/BLAPFSUtilities.c \
		src/bless/libbless/BootRoot/BLBootRootMapMemberToDevice.c \
		src/bless/libbless/BootRoot/BLBootRootMapMemberToHelper.c \
		src/bless/libbless/BootRoot/BLBootRootMapHelperToMember.c \
		src/bless/libbless/EFI/BLSetEFIBootDevice.c \
		src/bless/libbless/Misc/BLElToritoFindUEFI.c \
		src/bless/libbless/EFI/BLCreateEFIXMLRepresentationForElToritoEntry.c \
		src/bless/libbless/Misc/BLGetOSVersion.c
T_CFLAGS+=	-std=c99 -D_DARWIN_USE_64_BIT_INODE \
		-include ${T_SRCDIR}/bless-prefix.h -I${T_SRCDIR}/libbless \
		-I${T_SRCDIR} \
		-F${TOP}/frameworks
