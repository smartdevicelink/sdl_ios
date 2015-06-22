//  SDLButtonEventMode.m
//


#import "SDLButtonEventMode.h"

SDLButtonEventMode *SDLButtonEventMode_BUTTONUP = nil;
SDLButtonEventMode *SDLButtonEventMode_BUTTONDOWN = nil;

NSArray *SDLButtonEventMode_values = nil;

@implementation SDLButtonEventMode

+ (SDLButtonEventMode *)valueOf:(NSString *)value {
    for (SDLButtonEventMode *item in SDLButtonEventMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLButtonEventMode_values == nil) {
        SDLButtonEventMode_values = @[
            SDLButtonEventMode.BUTTONUP,
            SDLButtonEventMode.BUTTONDOWN,
        ];
    }
    return SDLButtonEventMode_values;
}

+ (SDLButtonEventMode *)BUTTONUP {
    if (SDLButtonEventMode_BUTTONUP == nil) {
        SDLButtonEventMode_BUTTONUP = [[SDLButtonEventMode alloc] initWithValue:@"BUTTONUP"];
    }
    return SDLButtonEventMode_BUTTONUP;
}

+ (SDLButtonEventMode *)BUTTONDOWN {
    if (SDLButtonEventMode_BUTTONDOWN == nil) {
        SDLButtonEventMode_BUTTONDOWN = [[SDLButtonEventMode alloc] initWithValue:@"BUTTONDOWN"];
    }
    return SDLButtonEventMode_BUTTONDOWN;
}

@end
