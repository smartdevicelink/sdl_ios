//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"




@implementation SDLHMICapabilities

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    return self;
}

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
