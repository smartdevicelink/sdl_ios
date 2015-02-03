//  SDLUpdateTurnListResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUpdateTurnListResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLUpdateTurnListResponse

-(id) init {
    if (self = [super initWithName:NAMES_UpdateTurnList]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
