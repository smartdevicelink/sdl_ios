//  SDLTouchEvent.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTouchEvent.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTouchCoord.h>

@implementation SDLTouchEvent

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setTouchEventId:(NSNumber*) touchEventId {
    [store setOrRemoveObject:touchEventId forKey:NAMES_id];
}

-(NSNumber*) touchEventId {
    return [store objectForKey:NAMES_id];
}

-(void) setTimeStamp:(NSMutableArray*) timeStamp {
    [store setOrRemoveObject:timeStamp forKey:NAMES_ts];
}

-(NSMutableArray*) timeStamp {
    return [store objectForKey:NAMES_ts];
}

-(void) setCoord:(NSMutableArray*) coord {
    [store setOrRemoveObject:coord forKey:NAMES_c];
}

-(NSMutableArray*) coord {
    NSMutableArray* array = [store objectForKey:NAMES_c];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTouchCoord.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTouchCoord alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
