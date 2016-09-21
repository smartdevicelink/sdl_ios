//
//  SDLSendLocationResponse.m
//  SmartDeviceLink-iOS

#import "SDLSendLocationResponse.h"




@implementation SDLSendLocationResponse

- (instancetype)init {
    self = [super initWithName:SDLNameSendLocation];
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

@end
