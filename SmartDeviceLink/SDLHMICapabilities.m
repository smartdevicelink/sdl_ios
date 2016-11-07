//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"

@implementation SDLHMICapabilities

- (void)setNavigation:(NSNumber<SDLBool> *)navigation {
    [self setObject:navigation forName:SDLNameNavigation];
}

- (NSNumber<SDLBool> *)navigation {
    return [self objectForName:SDLNameNavigation];
}

- (void)setPhoneCall:(NSNumber<SDLBool> *)phoneCall {
    [self setObject:phoneCall forName:SDLNamePhoneCall];
}

- (NSNumber<SDLBool> *)phoneCall {
    return [self objectForName:SDLNamePhoneCall];
}

@end
