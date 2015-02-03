//  SDLSubscribeButtonResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSubscribeButtonResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSubscribeButtonResponse

-(id) init {
    if (self = [super initWithName:NAMES_SubscribeButton]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
