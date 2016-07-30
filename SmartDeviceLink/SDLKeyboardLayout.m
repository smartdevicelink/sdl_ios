//  SDLKeyboardLayout.m
//


#import "SDLKeyboardLayout.h"

SDLKeyboardLayout *SDLKeyboardLayout_QWERTY = nil;
SDLKeyboardLayout *SDLKeyboardLayout_QWERTZ = nil;
SDLKeyboardLayout *SDLKeyboardLayout_AZERTY = nil;

NSArray *SDLKeyboardLayout_values = nil;

@implementation SDLKeyboardLayout

+ (SDLKeyboardLayout *)valueOf:(NSString *)value {
    for (SDLKeyboardLayout *item in SDLKeyboardLayout.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLKeyboardLayout_values == nil) {
        SDLKeyboardLayout_values = @[
            SDLKeyboardLayout.QWERTY,
            SDLKeyboardLayout.QWERTZ,
            SDLKeyboardLayout.AZERTY,
        ];
    }
    return SDLKeyboardLayout_values;
}

+ (SDLKeyboardLayout *)QWERTY {
    if (SDLKeyboardLayout_QWERTY == nil) {
        SDLKeyboardLayout_QWERTY = [[SDLKeyboardLayout alloc] initWithValue:@"QWERTY"];
    }
    return SDLKeyboardLayout_QWERTY;
}

+ (SDLKeyboardLayout *)QWERTZ {
    if (SDLKeyboardLayout_QWERTZ == nil) {
        SDLKeyboardLayout_QWERTZ = [[SDLKeyboardLayout alloc] initWithValue:@"QWERTZ"];
    }
    return SDLKeyboardLayout_QWERTZ;
}

+ (SDLKeyboardLayout *)AZERTY {
    if (SDLKeyboardLayout_AZERTY == nil) {
        SDLKeyboardLayout_AZERTY = [[SDLKeyboardLayout alloc] initWithValue:@"AZERTY"];
    }
    return SDLKeyboardLayout_AZERTY;
}

@end
