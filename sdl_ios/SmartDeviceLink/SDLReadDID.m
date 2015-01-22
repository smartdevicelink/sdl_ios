//  SDLReadDID.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLReadDID.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLReadDID

-(id) init {
    if (self = [super initWithName:NAMES_ReadDID]) {}
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

- (void)setDidLocation:(NSMutableArray *)didLocation {
    [parameters setOrRemoveObject:didLocation forKey:NAMES_didLocation];
}

-(NSMutableArray*) didLocation {
    return [parameters objectForKey:NAMES_didLocation];
}

@end
