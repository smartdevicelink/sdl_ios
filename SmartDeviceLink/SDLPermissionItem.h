//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

/// Permissions for a given set of RPCs
///
/// @since RPC 2.0
@interface SDLPermissionItem : SDLRPCStruct

/**
 Name of the individual RPC in the policy table.

 Required
 */
@property (strong, nonatomic) NSString *rpcName;

/**
 HMI Permissions for the individual RPC; i.e. which HMI levels may it be used in

 Required
 */
@property (strong, nonatomic) SDLHMIPermissions *hmiPermissions;

/**
 RPC parameters for the individual RPC

 Required
 */
@property (strong, nonatomic) SDLParameterPermissions *parameterPermissions;

/**
 Describes whether or not the RPC needs encryption
 
 Optional, Boolean, since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *requireEncryption;

@end

NS_ASSUME_NONNULL_END
