//  SDLAddCommandResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAddCommandResponse.h"

#import "SDLNames.h"

@implementation SDLAddCommandResponse

-(id) init {
    if (self = [super initWithName:NAMES_AddCommand]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
