//  SDLOnDriverDistraction.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnDriverDistraction.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnDriverDistraction

-(id) init {
    if (self = [super initWithName:NAMES_OnDriverDistraction]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setState:(SDLDriverDistractionState *)state {
    [parameters setOrRemoveObject:state forKey:NAMES_state];
}

-(SDLDriverDistractionState*) state {
    NSObject* obj = [parameters objectForKey:NAMES_state];
    if ([obj isKindOfClass:SDLDriverDistractionState.class]) {
        return (SDLDriverDistractionState*)obj;
    } else {
        return [SDLDriverDistractionState valueOf:(NSString*)obj];
    }
}

@end
