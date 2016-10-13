//
//  SDLSendLocationResponse.m
//  SmartDeviceLink-iOS

#import "SDLSendLocationResponse.h"

#import "SDLNames.h"

@implementation SDLSendLocationResponse

- (instancetype)init {
    self = [super initWithName:SDLNameSendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

@end
