//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"

@implementation SDLHMICapabilities

- (void)setNavigation:(NSNumber *)navigation {
    if (navigation != nil) {
        store[SDLNameNavigation] = navigation;
    } else {
        [store removeObjectForKey:SDLNameNavigation];
    }
}

- (NSNumber *)navigation {
    return store[SDLNameNavigation];
}

- (void)setPhoneCall:(NSNumber *)phoneCall {
    if (phoneCall != nil) {
        store[SDLNamePhoneCall] = phoneCall;
    } else {
        [store removeObjectForKey:SDLNamePhoneCall];
    }
}

- (NSNumber *)phoneCall {
    return store[SDLNamePhoneCall];
}

@end
