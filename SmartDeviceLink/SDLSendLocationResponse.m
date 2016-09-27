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

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    return self;
}

@end
