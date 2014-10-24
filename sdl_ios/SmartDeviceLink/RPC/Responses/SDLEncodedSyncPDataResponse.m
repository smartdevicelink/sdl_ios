//  SDLEncodedSyncPDataResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLEncodedSyncPDataResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLEncodedSyncPDataResponse

-(id) init {
    if (self = [super initWithName:NAMES_EncodedSyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
