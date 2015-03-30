//  SDLPermissionItem.h
//



#import "SDLRPCMessage.h"

#import "SDLHMIPermissions.h"
#import "SDLParameterPermissions.h"

@interface SDLPermissionItem : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* rpcName;
@property(strong) SDLHMIPermissions* hmiPermissions;
@property(strong) SDLParameterPermissions* parameterPermissions;

@end
