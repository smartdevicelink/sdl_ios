//  SDLAlertManeuverResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAlertManeuverResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAlertManeuverResponse

-(id) init {
    if (self = [super initWithName:NAMES_AlertManeuver]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
