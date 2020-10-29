//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMIPermissions.h"
#import "SDLRPCParameterNames.h"
#import "SDLParameterPermissions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionItem

- (instancetype)initWithRpcName:(NSString *)rpcName hmiPermissions:(SDLHMIPermissions *)hmiPermissions parameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.rpcName = rpcName;
    self.hmiPermissions = hmiPermissions;
    self.parameterPermissions = parameterPermissions;
    return self;
}

- (instancetype)initWithRpcName:(NSString *)rpcName hmiPermissions:(SDLHMIPermissions *)hmiPermissions parameterPermissions:(SDLParameterPermissions *)parameterPermissions requireEncryption:(nullable NSNumber<SDLBool> *)requireEncryption {
    self = [self initWithRpcName:rpcName hmiPermissions:hmiPermissions parameterPermissions:parameterPermissions];
    if (!self) {
        return nil;
    }
    self.requireEncryption = requireEncryption;
    return self;
}

- (void)setRpcName:(NSString *)rpcName {
    [self.store sdl_setObject:rpcName forName:SDLRPCParameterNameRPCName];
}

- (NSString *)rpcName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRPCName ofClass:NSString.class error:&error];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [self.store sdl_setObject:hmiPermissions forName:SDLRPCParameterNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameHMIPermissions ofClass:SDLHMIPermissions.class error:&error];
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [self.store sdl_setObject:parameterPermissions forName:SDLRPCParameterNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameParameterPermissions ofClass:SDLParameterPermissions.class error:&error];
}

- (void)setRequireEncryption:(nullable NSNumber<SDLBool> *)requireEncryption {
    [self.store sdl_setObject:requireEncryption forName:SDLRPCParameterNameRequireEncryption];
}

- (nullable NSNumber<SDLBool> *)requireEncryption {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRequireEncryption ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
