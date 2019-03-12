//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMICapabilities

- (void)setNavigation:(nullable NSNumber<SDLBool> *)navigation {
    [store sdl_setObject:navigation forName:SDLRPCParameterNameNavigation];
}

- (nullable NSNumber<SDLBool> *)navigation {
    return [store sdl_objectForName:SDLRPCParameterNameNavigation];
}

- (void)setPhoneCall:(nullable NSNumber<SDLBool> *)phoneCall {
    [store sdl_setObject:phoneCall forName:SDLRPCParameterNamePhoneCall];
}

- (nullable NSNumber<SDLBool> *)phoneCall {
    return [store sdl_objectForName:SDLRPCParameterNamePhoneCall];
}

- (void)setVideoStreaming:(nullable NSNumber<SDLBool> *)videoStreaming {
    [store sdl_setObject:videoStreaming forName:SDLRPCParameterNameVideoStreaming];
}

- (nullable NSNumber<SDLBool> *)videoStreaming {
    return [store sdl_objectForName:SDLRPCParameterNameVideoStreaming];
}

@end

NS_ASSUME_NONNULL_END
