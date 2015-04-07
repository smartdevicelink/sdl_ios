//
//  SDLBaseTransportConfig.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLBaseTransportConfig.h"

@implementation SDLBaseTransportConfig

-(instancetype)init{
    self = [super init];
    if (self) {
        _transportType = SDLTransportTypeiAP;
        _shareConnection = NO;
    }
    return self;
}

@end
