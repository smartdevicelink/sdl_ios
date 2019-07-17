//
//  SDLDisplayCapability.m
//  SmartDeviceLink

#import "SDLDisplayCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLWindowTypeCapabilities.h"
#import "SDLWindowCapability.h"

@implementation SDLDisplayCapability

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [self init];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithDisplayName:(NSString *)displayName {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.displayName = displayName;
    return self;
}

- (instancetype)initWithDisplayName:(NSString *)displayName windowTypeSupported:(nullable SDLWindowTypeCapabilities *)windowTypeSupported windowCapabilities:(nullable SDLWindowCapability *)windowCapabilities{
    self = [self initWithDisplayName:displayName];
    if (!self) {
        return nil;
    }
    self.windowTypeSupported = windowTypeSupported;
    self.windowCapabilities = windowCapabilities;
    return self;
}

- (void)setDisplayName:(NSString *)displayName {
    [self.store sdl_setObject:displayName forName:SDLRPCParameterNameTimezoneMinuteOffset];
}

- (NSString *)displayName {
    return [self.store sdl_objectForName:SDLRPCParameterNameTimezoneMinuteOffset ofClass:NSString.class error:nil];
}

- (void)setWindowTypeSupported:(nullable SDLWindowTypeCapabilities *)windowTypeSupported {
    [self.store sdl_setObject:windowTypeSupported forName:SDLRPCParameterNameWindowTypeSupported];
}

- (nullable SDLWindowTypeCapabilities *)windowTypeSupported {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowTypeSupported ofClass:SDLWindowTypeCapabilities.class error:nil];
}

- (void)setWindowCapabilities:(nullable SDLWindowCapability *)windowCapabilities {
    [self.store sdl_setObject:windowCapabilities forName:SDLRPCParameterNameWindowCapabilities];
}

- (nullable SDLWindowCapability *)windowCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowCapabilities ofClass:SDLWindowCapability.class error:nil];
}


@end
