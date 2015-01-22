//  SDLOnHashChange.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnHashChange.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnHashChange

-(id) init {
    if (self = [super initWithName:NAMES_OnHashChange]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setHashID:(NSString *)hashID {
    [parameters setOrRemoveObject:hashID forKey:NAMES_hashID];
}

-(NSString*) hashID {
    return [parameters objectForKey:NAMES_hashID];
}

@end
