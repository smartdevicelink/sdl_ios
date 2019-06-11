//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

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
 
 Optional boolean available since core 5.1
 */
@property (strong, nonatomic) NSNumber<SDLBool> *requireEncryption;

@end

NS_ASSUME_NONNULL_END
