//  SDLTouchType.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTouchType.h>

SDLTouchType* SDLTouchType_BEGIN = nil;
SDLTouchType* SDLTouchType_MOVE = nil;
SDLTouchType* SDLTouchType_END = nil;

NSMutableArray* SDLTouchType_values = nil;

@implementation SDLTouchType

+(SDLTouchType*) valueOf:(NSString*) value {
    for (SDLTouchType* item in SDLTouchType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLTouchType_values == nil) {
        SDLTouchType_values = [[NSMutableArray alloc] initWithObjects:
                SDLTouchType.BEGIN,
                SDLTouchType.MOVE,
                SDLTouchType.END,
                nil];
    }
    return SDLTouchType_values;
}

+(SDLTouchType*) BEGIN {
    if (SDLTouchType_BEGIN == nil) {
        SDLTouchType_BEGIN = [[SDLTouchType alloc] initWithValue:@"BEGIN"];
    }
    return SDLTouchType_BEGIN;
}

+(SDLTouchType*) MOVE {
    if (SDLTouchType_MOVE == nil) {
        SDLTouchType_MOVE = [[SDLTouchType alloc] initWithValue:@"MOVE"];
    }
    return SDLTouchType_MOVE;
}

+(SDLTouchType*) END {
    if (SDLTouchType_END == nil) {
        SDLTouchType_END = [[SDLTouchType alloc] initWithValue:@"END"];
    }
    return SDLTouchType_END;
}

@end
