//  SDLCreateInteractionChoiceSetResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLCreateInteractionChoiceSetResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLCreateInteractionChoiceSetResponse

-(id) init {
    if (self = [super initWithName:NAMES_CreateInteractionChoiceSet]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
