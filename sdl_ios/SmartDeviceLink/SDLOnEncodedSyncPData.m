//  SDLOnEncodedSyncPData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnEncodedSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnEncodedSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_OnEncodedSyncPData]) {}
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

- (void)setURL:(NSString *)URL {
    [parameters setOrRemoveObject:URL forKey:NAMES_URL];
}

-(NSString*) URL {
    return [parameters objectForKey:NAMES_URL];
}

- (void)setTimeout:(NSNumber *)Timeout {
    [parameters setOrRemoveObject:Timeout forKey:NAMES_Timeout];
}

-(NSNumber*) Timeout {
    return [parameters objectForKey:NAMES_Timeout];
}

@end
