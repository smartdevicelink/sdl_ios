//  SDLTimerMode.m
//


#import "SDLTimerMode.h"

SDLTimerMode *SDLTimerMode_UP = nil;
SDLTimerMode *SDLTimerMode_DOWN = nil;
SDLTimerMode *SDLTimerMode_NONE = nil;

NSArray *SDLTimerMode_values = nil;

@implementation SDLTimerMode

+ (SDLTimerMode *)valueOf:(NSString *)value {
    for (SDLTimerMode *item in SDLTimerMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTimerMode_values == nil) {
        SDLTimerMode_values = @[
            SDLTimerMode.UP,
            SDLTimerMode.DOWN,
            SDLTimerMode.NONE,
        ];
    }
    return SDLTimerMode_values;
}

+ (SDLTimerMode *)UP {
    if (SDLTimerMode_UP == nil) {
        SDLTimerMode_UP = [[SDLTimerMode alloc] initWithValue:@"UP"];
    }
    return SDLTimerMode_UP;
}

+ (SDLTimerMode *)DOWN {
    if (SDLTimerMode_DOWN == nil) {
        SDLTimerMode_DOWN = [[SDLTimerMode alloc] initWithValue:@"DOWN"];
    }
    return SDLTimerMode_DOWN;
}

+ (SDLTimerMode *)NONE {
    if (SDLTimerMode_NONE == nil) {
        SDLTimerMode_NONE = [[SDLTimerMode alloc] initWithValue:@"NONE"];
    }
    return SDLTimerMode_NONE;
}

@end
