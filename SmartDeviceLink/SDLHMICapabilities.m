//
//  SDLHMICapabilities.m
//  SmartDeviceLink-iOS

#import "SDLHMICapabilities.h"

#import "SDLNames.h"

@implementation SDLHMICapabilities

- (void)setNavigation:(NSNumber<SDLBool> *)navigation {
    [store sdl_setObject:navigation forName:SDLNameNavigation];
}

- (NSNumber<SDLBool> *)navigation {
    return [store sdl_objectForName:SDLNameNavigation];
}

- (void)setPhoneCall:(NSNumber<SDLBool> *)phoneCall {
    [store sdl_setObject:phoneCall forName:SDLNamePhoneCall];
}

- (NSNumber<SDLBool> *)phoneCall {
    return [store sdl_objectForName:SDLNamePhoneCall];
}

@end
