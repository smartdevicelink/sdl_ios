//  SDLGetDTCsResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLGetDTCsResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLGetDTCsResponse

-(id) init {
    if (self = [super initWithName:NAMES_GetDTCs]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setEcuHeader:(NSNumber *)ecuHeader {
    [parameters setOrRemoveObject:ecuHeader forKey:NAMES_ecuHeader];
}

-(NSNumber*) ecuHeader {
    return [parameters objectForKey:NAMES_ecuHeader];
}

- (void)setDtc:(NSMutableArray *)dtc {
    [parameters setOrRemoveObject:dtc forKey:NAMES_dtc];
}

-(NSMutableArray*) dtc {
    return [parameters objectForKey:NAMES_dtc];
}

@end
