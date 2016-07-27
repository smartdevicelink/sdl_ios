//  SDLPermissionItem.h
//

#import "SDLRPCMessage.h"

@class SDLHMIPermissions;
@class SDLParameterPermissions;


@interface SDLPermissionItem : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSString *rpcName;
@property (strong) SDLHMIPermissions *hmiPermissions;
@property (strong) SDLParameterPermissions *parameterPermissions;

@end
