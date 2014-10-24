//  SDLUnsubscribeButtonResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUnsubscribeButtonResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLUnsubscribeButtonResponse

-(id) init {
    if (self = [super initWithName:NAMES_UnsubscribeButton]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
