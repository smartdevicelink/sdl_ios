//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMIPermissions.h"
#import "SDLNames.h"
#import "SDLParameterPermissions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    [store sdl_setObject:rpcName forName:SDLNameRPCName];
}

- (NSString *)rpcName {
    NSError *error;
    return [store sdl_objectForName:SDLNameRPCName ofClass:NSString.class error:&error];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [store sdl_setObject:hmiPermissions forName:SDLNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    NSError *error;
    return [store sdl_objectForName:SDLNameHMIPermissions ofClass:SDLHMIPermissions.class error:&error];
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [store sdl_setObject:parameterPermissions forName:SDLNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    NSError *error;
    return [store sdl_objectForName:SDLNameParameterPermissions ofClass:SDLParameterPermissions.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
