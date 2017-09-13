//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"


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
        store[NAMES_navigation] = navigation;
    } else {
        [store removeObjectForKey:NAMES_navigation];
    }
}

- (NSNumber *)navigation {
    return store[NAMES_navigation];
}

- (void)setPhoneCall:(NSNumber *)phoneCall {
    if (phoneCall != nil) {
        store[NAMES_phoneCall] = phoneCall;
    } else {
        [store removeObjectForKey:NAMES_phoneCall];
    }
}

- (NSNumber *)phoneCall {
    return store[NAMES_phoneCall];
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
