//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMICapabilities

- (void)setNavigation:(nullable NSNumber<SDLBool> *)navigation {
    if (navigation != nil) {
        store[SDLNameNavigation] = navigation;
    } else {
        [store removeObjectForKey:SDLNameNavigation];
    }
}

- (nullable NSNumber<SDLBool> *)navigation {
    return store[SDLNameNavigation];
}

- (void)setPhoneCall:(nullable NSNumber<SDLBool> *)phoneCall {
    if (phoneCall != nil) {
        store[SDLNamePhoneCall] = phoneCall;
    } else {
        [store removeObjectForKey:SDLNamePhoneCall];
    }
}

- (nullable NSNumber<SDLBool> *)phoneCall {
    return store[SDLNamePhoneCall];
}

@end

NS_ASSUME_NONNULL_END
