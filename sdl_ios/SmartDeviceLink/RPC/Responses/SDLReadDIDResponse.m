//  SDLReadDIDResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLReadDIDResponse.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLDIDResult.h>

@implementation SDLReadDIDResponse

-(id) init {
    if (self = [super initWithName:NAMES_ReadDID]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setDidResult:(NSMutableArray*) didResult {
    if (didResult != nil) {
        [parameters setObject:didResult forKey:NAMES_didResult];
    } else {
        [parameters removeObjectForKey:NAMES_didResult];
    }
}

-(NSMutableArray*) didResult {
    NSMutableArray* array = [parameters objectForKey:NAMES_didResult];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLDIDResult.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLDIDResult alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
