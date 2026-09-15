/*
 * KernelManagement_Private.h -- KernelManagementClient, the SPI class
 * kext_tools' KernelManagementShims send load requests through.
 *
 * Apple publish no source for KernelManagement.framework and the SDK
 * ships only its public KernelManagement.h, which declares none of this.
 * The interface below is not reconstructed by hand: it is the class as
 * ipsw class-dump reports it from the framework in the dyld shared cache
 * of macOS 26.5.2 (25F84), with the instance variable and the property that names
 * an undeclared protocol left out.  Types are as the runtime records
 * them.
 */
#ifndef _KERNELMANAGEMENT_PRIVATE_H_
#define _KERNELMANAGEMENT_PRIVATE_H_

#import <Foundation/Foundation.h>

@interface KernelManagementClient : NSObject

+ (id)sharedClient;

- (id)initWithConnection:(id)connection;
- (id)init;
- (id)connection;
- (_Bool)enumerateKernelExtension:(id /* block */)extension error:(id *)error;
- (_Bool)checkAllFilesets:(id *)filesets;
- (_Bool)clearAllStagedExtensions:(id *)extensions;
- (_Bool)daemonIsReachable;
- (id)dumpStateWithError:(id *)error;
- (id)getCollectionPathWithCollection:(id)collection withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withIdentifiers:(id)identifiers withNoAuth:(_Bool)auth withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withIdentifiers:(id)identifiers withPersonalityNames:(id)names options:(unsigned long long)options withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withIdentifiers:(id)identifiers withPersonalityNames:(id)names withDependencyAndFolderPaths:(id)dependencyPaths options:(unsigned long long)options withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withIdentifiers:(id)identifiers withPersonalityNames:(id)names withNoAuth:(_Bool)auth withError:(id *)error;
- (_Bool)loadExtensionsWithPaths:(id)paths withNoAuth:(_Bool)auth withError:(id *)error;
- (_Bool)migrateAuxKCForVolumeGroupUUID:(id)uuid withMigrationSuccess:(_Bool)success withRebootRequired:(_Bool *)required withError:(id *)error;
- (id)pathOfExtensionWithIdentifier:(id)identifier withError:(id *)error;
- (id)pathOfLoadableKernelCollectionOfType:(unsigned long long)type withError:(id *)error;
- (_Bool)rebuildAuxiliaryKernelCollectionWithInterface:(id)interface rebootRequired:(_Bool *)required withError:(id *)error;
- (_Bool)triggerAuxKCCleanup:(id)kccleanup withError:(id *)error;
- (_Bool)triggerPanicMedicInRecoveryWithPath:(id)path withError:(id *)error;
- (_Bool)unloadExtensionsWithIdentifiers:(id)identifiers withClassNames:(id)names options:(unsigned long long)options withError:(id *)error;

@end

#endif /* _KERNELMANAGEMENT_PRIVATE_H_ */
