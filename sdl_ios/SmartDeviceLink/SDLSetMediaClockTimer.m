//  SDLSetMediaClockTimer.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetMediaClockTimer.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetMediaClockTimer

-(id) init {
    if (self = [super initWithName:NAMES_SetMediaClockTimer]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setStartTime:(SDLStartTime *)startTime {
    [parameters setOrRemoveObject:startTime forKey:NAMES_startTime];
}

-(SDLStartTime*) startTime {
    NSObject* obj = [parameters objectForKey:NAMES_startTime];
    if ([obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime*)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setEndTime:(SDLStartTime *)endTime {
    [parameters setOrRemoveObject:endTime forKey:NAMES_endTime];
}

-(SDLStartTime*) endTime {
    NSObject* obj = [parameters objectForKey:NAMES_endTime];
    if ([obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime*)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setUpdateMode:(SDLUpdateMode *)updateMode {
    [parameters setOrRemoveObject:updateMode forKey:NAMES_updateMode];
}

-(SDLUpdateMode*) updateMode {
    NSObject* obj = [parameters objectForKey:NAMES_updateMode];
    if ([obj isKindOfClass:SDLUpdateMode.class]) {
        return (SDLUpdateMode*)obj;
    } else {
        return [SDLUpdateMode valueOf:(NSString*)obj];
    }
}

@end
