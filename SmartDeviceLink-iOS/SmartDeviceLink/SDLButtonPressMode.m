//  SDLButtonPressMode.m
//


#import "SDLButtonPressMode.h"

SDLButtonPressMode *SDLButtonPressMode_LONG = nil;
SDLButtonPressMode *SDLButtonPressMode_SHORT = nil;

NSArray *SDLButtonPressMode_values = nil;

@implementation SDLButtonPressMode

+ (SDLButtonPressMode *)valueOf:(NSString *)value {
    for (SDLButtonPressMode *item in SDLButtonPressMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLButtonPressMode_values == nil) {
        SDLButtonPressMode_values = @[
            SDLButtonPressMode.LONG,
            SDLButtonPressMode.SHORT,
        ];
    }
    return SDLButtonPressMode_values;
}

+ (SDLButtonPressMode *)LONG {
    if (SDLButtonPressMode_LONG == nil) {
        SDLButtonPressMode_LONG = [[SDLButtonPressMode alloc] initWithValue:@"LONG"];
    }
    return SDLButtonPressMode_LONG;
}

+ (SDLButtonPressMode *)SHORT {
    if (SDLButtonPressMode_SHORT == nil) {
        SDLButtonPressMode_SHORT = [[SDLButtonPressMode alloc] initWithValue:@"SHORT"];
    }
    return SDLButtonPressMode_SHORT;
}

@end
