//  SDLSystemRequestResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLSystemRequestResponse.h"

#import "SDLNames.h"

@implementation SDLSystemRequestResponse

-(id) init {
    if (self = [super initWithName:NAMES_SystemRequest]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
