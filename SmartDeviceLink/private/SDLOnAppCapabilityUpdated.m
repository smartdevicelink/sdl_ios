//
//  SDLOnAppCapabilityUpdated.m
//  SmartDeviceLink
//

#import "NSMutableDictionary+Store.h"
#import "SDLAppCapability.h"
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppCapabilityUpdated

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self = [super initWithName:SDLRPCFunctionNameOnAppCapabilityUpdated];
#pragma clang diagnostic pop
    return self;
}

- (instancetype)initWithAppCapability:(SDLAppCapability *)appCapability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appCapability = appCapability;

    return self;
}

- (void)setAppCapability:(SDLAppCapability *)appCapability {
    [self.parameters sdl_setObject:appCapability forName:SDLRPCParameterNameAppCapability];
}

- (SDLAppCapability *)appCapability {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppCapability ofClass:SDLAppCapability.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
