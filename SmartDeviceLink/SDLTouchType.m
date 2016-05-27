//  SDLTouchType.m
//


#import "SDLTouchType.h"

SDLTouchType *SDLTouchType_BEGIN = nil;
SDLTouchType *SDLTouchType_MOVE = nil;
SDLTouchType *SDLTouchType_END = nil;

NSArray *SDLTouchType_values = nil;

@implementation SDLTouchType

+ (SDLTouchType *)valueOf:(NSString *)value {
    for (SDLTouchType *item in SDLTouchType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTouchType_values == nil) {
        SDLTouchType_values = @[
            SDLTouchType.BEGIN,
            SDLTouchType.MOVE,
            SDLTouchType.END,
        ];
    }
    return SDLTouchType_values;
}

+ (SDLTouchType *)BEGIN {
    if (SDLTouchType_BEGIN == nil) {
        SDLTouchType_BEGIN = [[SDLTouchType alloc] initWithValue:@"BEGIN"];
    }
    return SDLTouchType_BEGIN;
}

+ (SDLTouchType *)MOVE {
    if (SDLTouchType_MOVE == nil) {
        SDLTouchType_MOVE = [[SDLTouchType alloc] initWithValue:@"MOVE"];
    }
    return SDLTouchType_MOVE;
}

+ (SDLTouchType *)END {
    if (SDLTouchType_END == nil) {
        SDLTouchType_END = [[SDLTouchType alloc] initWithValue:@"END"];
    }
    return SDLTouchType_END;
}

@end
