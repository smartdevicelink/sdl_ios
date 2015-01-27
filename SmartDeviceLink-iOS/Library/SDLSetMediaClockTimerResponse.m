//  SDLSetMediaClockTimerResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLSetMediaClockTimerResponse.h"

#import "SDLNames.h"

@implementation SDLSetMediaClockTimerResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetMediaClockTimer]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
