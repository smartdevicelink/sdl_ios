//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"

@implementation SDLHMICapabilities

- (void)setNavigation:(NSNumber<SDLBool> *)navigation {
    if (navigation != nil) {
        store[SDLNameNavigation] = navigation;
    } else {
        [store removeObjectForKey:SDLNameNavigation];
    }
}

- (NSNumber<SDLBool> *)navigation {
    return store[SDLNameNavigation];
}

- (void)setPhoneCall:(NSNumber<SDLBool> *)phoneCall {
    if (phoneCall != nil) {
        store[SDLNamePhoneCall] = phoneCall;
    } else {
        [store removeObjectForKey:SDLNamePhoneCall];
    }
}

- (NSNumber<SDLBool> *)phoneCall {
    return store[SDLNamePhoneCall];
}

@end
