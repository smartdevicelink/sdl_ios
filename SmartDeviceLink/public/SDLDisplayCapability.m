//
//  SDLDisplayCapability.m
//  SmartDeviceLink

#import "SDLDisplayCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLWindowTypeCapabilities.h"
#import "SDLWindowCapability.h"

@implementation SDLDisplayCapability

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (instancetype)initWithDisplayName:(NSString *)displayName {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.displayName = displayName;
    return self;
}

- (instancetype)initWithDisplayName:(NSString *)displayName windowCapabilities:(nullable NSArray<SDLWindowCapability *> *)windowCapabilities windowTypeSupported:(nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported {
    self = [self initWithDisplayName:displayName];
    if (!self) {
        return nil;
    }
    self.windowTypeSupported = windowTypeSupported;
    self.windowCapabilities = windowCapabilities;
    return self;
}

- (void)setDisplayName:(NSString *)displayName {
    [self.store sdl_setObject:displayName forName:SDLRPCParameterNameDisplayName];
}

- (NSString *)displayName {
    return [self.store sdl_objectForName:SDLRPCParameterNameDisplayName ofClass:NSString.class error:nil];
}

- (void)setWindowTypeSupported:(nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported {
    [self.store sdl_setObject:windowTypeSupported forName:SDLRPCParameterNameWindowTypeSupported];
}

- (nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported {
    return [self.store sdl_objectsForName:SDLRPCParameterNameWindowTypeSupported ofClass:SDLWindowTypeCapabilities.class error:nil];
}

- (void)setWindowCapabilities:(nullable NSArray<SDLWindowCapability *>  *)windowCapabilities {
    [self.store sdl_setObject:windowCapabilities forName:SDLRPCParameterNameWindowCapabilities];
}

- (nullable NSArray<SDLWindowCapability *> *)windowCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameWindowCapabilities ofClass:SDLWindowCapability.class error:nil];
}


@end
