//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "SDLHMIPermissions.h"
#import "SDLNames.h"
#import "SDLParameterPermissions.h"

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    [self setObject:rpcName forName:SDLNameRPCName];
}

- (NSString *)rpcName {
    return [self objectForName:SDLNameRPCName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [self setObject:hmiPermissions forName:SDLNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    NSObject *obj = [store objectForKey:SDLNameHMIPermissions];
    if (obj == nil || [obj isKindOfClass:SDLHMIPermissions.class]) {
        return (SDLHMIPermissions *)obj;
    } else {
        return [[SDLHMIPermissions alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [self setObject:parameterPermissions forName:SDLNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    NSObject *obj = [store objectForKey:SDLNameParameterPermissions];
    if (obj == nil || [obj isKindOfClass:SDLParameterPermissions.class]) {
        return (SDLParameterPermissions *)obj;
    } else {
        return [[SDLParameterPermissions alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
