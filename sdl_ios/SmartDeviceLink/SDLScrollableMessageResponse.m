//  SDLScrollableMessageResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLScrollableMessageResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLScrollableMessageResponse

-(id) init {
    if (self = [super initWithName:NAMES_ScrollableMessage]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
