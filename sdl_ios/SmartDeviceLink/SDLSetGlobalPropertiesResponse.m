//  SDLSetGlobalPropertiesResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetGlobalPropertiesResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetGlobalPropertiesResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
