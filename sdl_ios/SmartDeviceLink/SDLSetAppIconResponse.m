//  SDLSetAppIconResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetAppIconResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetAppIconResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetAppIcon]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
