//  SDLUnregisterAppInterface.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUnregisterAppInterface.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLUnregisterAppInterface

-(id) init {
    if (self = [super initWithName:NAMES_UnregisterAppInterface]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
