//  SDLListFiles.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLListFiles.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLListFiles

-(id) init {
    if (self = [super initWithName:NAMES_ListFiles]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
