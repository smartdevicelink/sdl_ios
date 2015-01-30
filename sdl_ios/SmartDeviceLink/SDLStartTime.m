//  SDLStartTime.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLStartTime.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLStartTime

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setHours:(NSNumber*) hours {
    [store setOrRemoveObject:hours forKey:NAMES_hours];
}

-(NSNumber*) hours {
    return [store objectForKey:NAMES_hours];
}

-(void) setMinutes:(NSNumber*) minutes {
    [store setOrRemoveObject:minutes forKey:NAMES_minutes];
}

-(NSNumber*) minutes {
    return [store objectForKey:NAMES_minutes];
}

-(void) setSeconds:(NSNumber*) seconds {
    [store setOrRemoveObject:seconds forKey:NAMES_seconds];
}

-(NSNumber*) seconds {
    return [store objectForKey:NAMES_seconds];
}

@end
