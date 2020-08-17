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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnAppCapabilityUpdated]) {
    }
    return self;
}
#pragma clang diagnostic pop

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
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppCapability ofClass:SDLAppCapability.class error:NULL];
}

@end

NS_ASSUME_NONNULL_END
