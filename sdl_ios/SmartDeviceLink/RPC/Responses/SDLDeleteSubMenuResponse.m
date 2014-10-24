//  SDLDeleteSubMenuResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteSubMenuResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteSubMenuResponse

-(id) init {
    if (self = [super initWithName:NAMES_DeleteSubMenu]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
