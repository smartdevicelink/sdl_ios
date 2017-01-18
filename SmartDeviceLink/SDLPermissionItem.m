//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMIPermissions.h"
#import "SDLNames.h"
#import "SDLParameterPermissions.h"

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    [store sdl_setObject:rpcName forName:SDLNameRPCName];
}

- (NSString *)rpcName {
    return [store sdl_objectForName:SDLNameRPCName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [store sdl_setObject:hmiPermissions forName:SDLNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    return [store sdl_objectForName:SDLNameHMIPermissions ofClass:SDLHMIPermissions.class];
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [store sdl_setObject:parameterPermissions forName:SDLNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    return [store sdl_objectForName:SDLNameParameterPermissions ofClass:SDLParameterPermissions.class];
}

@end
