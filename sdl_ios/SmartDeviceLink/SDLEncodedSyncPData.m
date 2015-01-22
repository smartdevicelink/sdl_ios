//  SDLEncodedSyncPData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLEncodedSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLEncodedSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_EncodedSyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setData:(NSMutableArray *)data {
    [parameters setOrRemoveObject:data forKey:NAMES_data];
}

-(NSMutableArray*) data {
    return [parameters objectForKey:NAMES_data];
}

@end
