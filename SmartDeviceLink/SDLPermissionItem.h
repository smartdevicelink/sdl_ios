//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionItem : SDLRPCStruct

@property (strong, nonatomic) NSString *rpcName;
@property (strong, nonatomic) SDLHMIPermissions *hmiPermissions;
@property (strong, nonatomic) SDLParameterPermissions *parameterPermissions;

@end

NS_ASSUME_NONNULL_END
