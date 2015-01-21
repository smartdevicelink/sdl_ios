//  SDLOnSyncPData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_OnSyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
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
