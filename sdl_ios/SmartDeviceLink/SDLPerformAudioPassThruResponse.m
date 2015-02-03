//  SDLPerformAudioPassThruResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPerformAudioPassThruResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLPerformAudioPassThruResponse

-(id) init {
    if (self = [super initWithName:NAMES_PerformAudioPassThru]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
