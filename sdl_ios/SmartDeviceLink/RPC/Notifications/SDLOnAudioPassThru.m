//  SDLOnAudioPassThru.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnAudioPassThru.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnAudioPassThru

-(id) init {
    if (self = [super initWithName:NAMES_OnAudioPassThru]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
