//
//  SDLSendLocationResponse.m
//  SmartDeviceLink-iOS

#import "SDLSendLocationResponse.h"

#import "SDLNames.h"


@implementation SDLSendLocationResponse

- (instancetype)init {
    self = [super initWithName:NAMES_SendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

@end
