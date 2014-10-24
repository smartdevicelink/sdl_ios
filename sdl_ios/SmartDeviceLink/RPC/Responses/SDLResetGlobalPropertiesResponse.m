//  SDLResetGlobalPropertiesResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLResetGlobalPropertiesResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLResetGlobalPropertiesResponse

-(id) init {
    if (self = [super initWithName:NAMES_ResetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
