//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "SDLHMIPermissions.h"

#import "SDLParameterPermissions.h"


@implementation SDLPermissionItem

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setRpcName:(NSString *)rpcName {
    if (rpcName != nil) {
        [store setObject:rpcName forKey:SDLNameRpcName];
    } else {
        [store removeObjectForKey:SDLNameRpcName];
    }
}

- (NSString *)rpcName {
    return [store objectForKey:SDLNameRpcName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    if (hmiPermissions != nil) {
        [store setObject:hmiPermissions forKey:SDLNameHmiPermissions];
    } else {
        [store removeObjectForKey:SDLNameHmiPermissions];
    }
}

- (SDLHMIPermissions *)hmiPermissions {
    NSObject *obj = [store objectForKey:SDLNameHmiPermissions];
    if (obj == nil || [obj isKindOfClass:SDLHMIPermissions.class]) {
        return (SDLHMIPermissions *)obj;
    } else {
        return [[SDLHMIPermissions alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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
    if (obj == nil || [obj isKindOfClass:SDLParameterPermissions.class]) {
        return (SDLParameterPermissions *)obj;
    } else {
        return [[SDLParameterPermissions alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
