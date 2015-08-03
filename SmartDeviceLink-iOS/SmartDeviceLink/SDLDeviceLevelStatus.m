//  SDLDeviceLevelStatus.m
//


#import "SDLDeviceLevelStatus.h"

SDLDeviceLevelStatus *SDLDeviceLevelStatus_ZERO_LEVEL_BARS = nil;
SDLDeviceLevelStatus *SDLDeviceLevelStatus_ONE_LEVEL_BARS = nil;
SDLDeviceLevelStatus *SDLDeviceLevelStatus_TWO_LEVEL_BARS = nil;
SDLDeviceLevelStatus *SDLDeviceLevelStatus_THREE_LEVEL_BARS = nil;
SDLDeviceLevelStatus *SDLDeviceLevelStatus_FOUR_LEVEL_BARS = nil;
SDLDeviceLevelStatus *SDLDeviceLevelStatus_NOT_PROVIDED = nil;

NSArray *SDLDeviceLevelStatus_values = nil;

@implementation SDLDeviceLevelStatus

+ (SDLDeviceLevelStatus *)valueOf:(NSString *)value {
    for (SDLDeviceLevelStatus *item in SDLDeviceLevelStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLDeviceLevelStatus_values == nil) {
        SDLDeviceLevelStatus_values = @[
            SDLDeviceLevelStatus.ZERO_LEVEL_BARS,
            SDLDeviceLevelStatus.ONE_LEVEL_BARS,
            SDLDeviceLevelStatus.TWO_LEVEL_BARS,
            SDLDeviceLevelStatus.THREE_LEVEL_BARS,
            SDLDeviceLevelStatus.FOUR_LEVEL_BARS,
            SDLDeviceLevelStatus.NOT_PROVIDED,
        ];
    }
    return SDLDeviceLevelStatus_values;
}

+ (SDLDeviceLevelStatus *)ZERO_LEVEL_BARS {
    if (SDLDeviceLevelStatus_ZERO_LEVEL_BARS == nil) {
        SDLDeviceLevelStatus_ZERO_LEVEL_BARS = [[SDLDeviceLevelStatus alloc] initWithValue:@"ZERO_LEVEL_BARS"];
    }
    return SDLDeviceLevelStatus_ZERO_LEVEL_BARS;
}

+ (SDLDeviceLevelStatus *)ONE_LEVEL_BARS {
    if (SDLDeviceLevelStatus_ONE_LEVEL_BARS == nil) {
        SDLDeviceLevelStatus_ONE_LEVEL_BARS = [[SDLDeviceLevelStatus alloc] initWithValue:@"ONE_LEVEL_BARS"];
    }
    return SDLDeviceLevelStatus_ONE_LEVEL_BARS;
}

+ (SDLDeviceLevelStatus *)TWO_LEVEL_BARS {
    if (SDLDeviceLevelStatus_TWO_LEVEL_BARS == nil) {
        SDLDeviceLevelStatus_TWO_LEVEL_BARS = [[SDLDeviceLevelStatus alloc] initWithValue:@"TWO_LEVEL_BARS"];
    }
    return SDLDeviceLevelStatus_TWO_LEVEL_BARS;
}

+ (SDLDeviceLevelStatus *)THREE_LEVEL_BARS {
    if (SDLDeviceLevelStatus_THREE_LEVEL_BARS == nil) {
        SDLDeviceLevelStatus_THREE_LEVEL_BARS = [[SDLDeviceLevelStatus alloc] initWithValue:@"THREE_LEVEL_BARS"];
    }
    return SDLDeviceLevelStatus_THREE_LEVEL_BARS;
}

+ (SDLDeviceLevelStatus *)FOUR_LEVEL_BARS {
    if (SDLDeviceLevelStatus_FOUR_LEVEL_BARS == nil) {
        SDLDeviceLevelStatus_FOUR_LEVEL_BARS = [[SDLDeviceLevelStatus alloc] initWithValue:@"FOUR_LEVEL_BARS"];
    }
    return SDLDeviceLevelStatus_FOUR_LEVEL_BARS;
}

+ (SDLDeviceLevelStatus *)NOT_PROVIDED {
    if (SDLDeviceLevelStatus_NOT_PROVIDED == nil) {
        SDLDeviceLevelStatus_NOT_PROVIDED = [[SDLDeviceLevelStatus alloc] initWithValue:@"NOT_PROVIDED"];
    }
    return SDLDeviceLevelStatus_NOT_PROVIDED;
}

@end
