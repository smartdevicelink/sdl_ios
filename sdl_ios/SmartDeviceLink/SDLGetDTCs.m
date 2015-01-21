//  SDLGetDTCs.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLGetDTCs.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLGetDTCs

-(id) init {
    if (self = [super initWithName:NAMES_GetDTCs]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setEcuName:(NSNumber *)ecuName {
    [parameters setOrRemoveObject:ecuName forKey:NAMES_ecuName];
}

-(NSNumber*) ecuName {
    return [parameters objectForKey:NAMES_ecuName];
}

- (void)setDtcMask:(NSNumber *)dtcMask {
    [parameters setOrRemoveObject:dtcMask forKey:NAMES_dtcMask];
}

-(NSNumber*) dtcMask {
    return [parameters objectForKey:NAMES_dtcMask];
}

@end
