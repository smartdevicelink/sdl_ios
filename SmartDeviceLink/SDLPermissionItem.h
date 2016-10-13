//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;


@interface SDLPermissionItem : SDLRPCStruct

@property (strong) NSString *rpcName;
@property (strong) SDLHMIPermissions *hmiPermissions;
@property (strong) SDLParameterPermissions *parameterPermissions;

@end
