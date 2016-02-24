//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "SDLHMIPermissions.h"
#import "SDLNames.h"
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
        [store setObject:rpcName forKey:NAMES_rpcName];
    } else {
        [store removeObjectForKey:NAMES_rpcName];
    }
}

- (NSString *)rpcName {
    return [store objectForKey:NAMES_rpcName];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    if (hmiPermissions != nil) {
        [store setObject:hmiPermissions forKey:NAMES_hmiPermissions];
    } else {
        [store removeObjectForKey:NAMES_hmiPermissions];
    }
}

- (SDLHMIPermissions *)hmiPermissions {
    NSObject *obj = [store objectForKey:NAMES_hmiPermissions];
    if (obj == nil || [obj isKindOfClass:SDLHMIPermissions.class]) {
        return (SDLHMIPermissions *)obj;
    } else {
        return [[SDLHMIPermissions alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    if (parameterPermissions != nil) {
        [store setObject:parameterPermissions forKey:NAMES_parameterPermissions];
    } else {
        [store removeObjectForKey:NAMES_parameterPermissions];
    }
}

- (SDLParameterPermissions *)parameterPermissions {
    NSObject *obj = [store objectForKey:NAMES_parameterPermissions];
    if (obj == nil || [obj isKindOfClass:SDLParameterPermissions.class]) {
        return (SDLParameterPermissions *)obj;
    } else {
        return [[SDLParameterPermissions alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
