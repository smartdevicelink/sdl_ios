//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMIPermissions.h"
#import "SDLRPCParameterNames.h"
#import "SDLParameterPermissions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    [store sdl_setObject:rpcName forName:SDLRPCParameterNameRPCName];
}

- (NSString *)rpcName {
    return [store sdl_objectForName:SDLRPCParameterNameRPCName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [store sdl_setObject:hmiPermissions forName:SDLRPCParameterNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    return [store sdl_objectForName:SDLRPCParameterNameHMIPermissions ofClass:SDLHMIPermissions.class];
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [store sdl_setObject:parameterPermissions forName:SDLRPCParameterNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    return [store sdl_objectForName:SDLRPCParameterNameParameterPermissions ofClass:SDLParameterPermissions.class];
}

@end

NS_ASSUME_NONNULL_END
