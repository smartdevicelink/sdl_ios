//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMICapabilities

- (void)setNavigation:(nullable NSNumber<SDLBool> *)navigation {
    [store sdl_setObject:navigation forName:SDLNameNavigation];
}

- (nullable NSNumber<SDLBool> *)navigation {
    return [store sdl_objectForName:SDLNameNavigation];
}

- (void)setPhoneCall:(nullable NSNumber<SDLBool> *)phoneCall {
    [store sdl_setObject:phoneCall forName:SDLNamePhoneCall];
}

- (nullable NSNumber<SDLBool> *)phoneCall {
    return [store sdl_objectForName:SDLNamePhoneCall];
}

- (void)setVideoStreaming:(nullable NSNumber<SDLBool> *)videoStreaming {
    [store sdl_setObject:videoStreaming forName:SDLNameVideoStreaming];
}

- (nullable NSNumber<SDLBool> *)videoStreaming {
    return [store sdl_objectForName:SDLNameVideoStreaming];
}

- (void)setVideoStreaming:(NSNumber *)videoStreaming {
    if (videoStreaming != nil) {
        store[NAMES_videoStreaming] = videoStreaming;
    } else {
        [store removeObjectForKey:NAMES_videoStreaming];
    }
}

- (NSNumber *)videoStreaming {
    return store[NAMES_videoStreaming];
}

@end

NS_ASSUME_NONNULL_END
