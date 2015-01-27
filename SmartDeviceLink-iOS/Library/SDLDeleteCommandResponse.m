//  SDLDeleteCommandResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLDeleteCommandResponse.h"

#import "SDLNames.h"

@implementation SDLDeleteCommandResponse

-(id) init {
    if (self = [super initWithName:NAMES_DeleteCommand]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
