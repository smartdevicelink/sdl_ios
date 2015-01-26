//  SDLResetGlobalPropertiesResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLResetGlobalPropertiesResponse.h"

#import "SDLNames.h"

@implementation SDLResetGlobalPropertiesResponse

-(id) init {
    if (self = [super initWithName:NAMES_ResetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
