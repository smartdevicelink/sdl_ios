//  SDLChangeRegistrationResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLChangeRegistrationResponse.h"

#import "SDLNames.h"

@implementation SDLChangeRegistrationResponse

-(id) init {
    if (self = [super initWithName:NAMES_ChangeRegistration]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
