//  SDLAddSubMenuResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAddSubMenuResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAddSubMenuResponse

-(id) init {
    if (self = [super initWithName:NAMES_AddSubMenu]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
