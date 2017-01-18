//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;


@interface SDLPermissionItem : SDLRPCStruct

@property (strong, nonatomic) NSString *rpcName;
@property (strong, nonatomic) SDLHMIPermissions *hmiPermissions;
@property (strong, nonatomic) SDLParameterPermissions *parameterPermissions;

@end
