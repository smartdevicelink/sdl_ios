//  SDLSetGlobalPropertiesResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLSetGlobalPropertiesResponse.h"

#import "SDLNames.h"

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
