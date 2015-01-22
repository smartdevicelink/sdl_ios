//  SDLTouchCoord.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTouchCoord.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTouchCoord

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setX:(NSNumber*) x {
    [store setOrRemoveObject:x forKey:NAMES_x];
}

-(NSNumber*) x {
    return [store objectForKey:NAMES_x];
}

-(void) setY:(NSNumber*) y {
    [store setOrRemoveObject:y forKey:NAMES_y];
}

-(NSNumber*) y {
    return [store objectForKey:NAMES_y];
}

@end
