//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionItem : SDLRPCStruct

@property (strong) NSString *rpcName;
@property (strong) SDLHMIPermissions *hmiPermissions;
@property (strong) SDLParameterPermissions *parameterPermissions;

@end

NS_ASSUME_NONNULL_END
