//  SDLGenericResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLGenericResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLGenericResponse

-(id) init {
    if (self = [super initWithName:NAMES_GenericResponse]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
