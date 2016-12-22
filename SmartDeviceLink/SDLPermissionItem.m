//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "SDLHMIPermissions.h"
#import "SDLNames.h"
#import "SDLParameterPermissions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    if (rpcName != nil) {
        [store setObject:rpcName forKey:SDLNameRPCName];
    } else {
        [store removeObjectForKey:SDLNameRPCName];
    }
}

- (NSString *)rpcName {
    return [store objectForKey:SDLNameRPCName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    if (hmiPermissions != nil) {
        [store setObject:hmiPermissions forKey:SDLNameHMIPermissions];
    } else {
        [store removeObjectForKey:SDLNameHMIPermissions];
    }
}

- (SDLHMIPermissions *)hmiPermissions {
    NSObject *obj = [store objectForKey:SDLNameHMIPermissions];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLHMIPermissions alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLHMIPermissions*)obj;
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    if (parameterPermissions != nil) {
        [store setObject:parameterPermissions forKey:SDLNameParameterPermissions];
    } else {
        [store removeObjectForKey:SDLNameParameterPermissions];
    }
}

- (SDLParameterPermissions *)parameterPermissions {
    NSObject *obj = [store objectForKey:SDLNameParameterPermissions];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLParameterPermissions alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLParameterPermissions*)obj;
}

@end

NS_ASSUME_NONNULL_END
