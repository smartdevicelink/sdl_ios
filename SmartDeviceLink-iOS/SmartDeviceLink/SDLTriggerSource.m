//  SDLTriggerSource.m
//


#import "SDLTriggerSource.h"

SDLTriggerSource *SDLTriggerSource_MENU = nil;
SDLTriggerSource *SDLTriggerSource_VR = nil;
SDLTriggerSource *SDLTriggerSource_KEYBOARD = nil;

NSArray *SDLTriggerSource_values = nil;

@implementation SDLTriggerSource

+ (SDLTriggerSource *)valueOf:(NSString *)value {
    for (SDLTriggerSource *item in SDLTriggerSource.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTriggerSource_values == nil) {
        SDLTriggerSource_values = @[
            SDLTriggerSource.MENU,
            SDLTriggerSource.VR,
            SDLTriggerSource.KEYBOARD,
        ];
    }
    return SDLTriggerSource_values;
}

+ (SDLTriggerSource *)MENU {
    if (SDLTriggerSource_MENU == nil) {
        SDLTriggerSource_MENU = [[SDLTriggerSource alloc] initWithValue:@"MENU"];
    }
    return SDLTriggerSource_MENU;
}

+ (SDLTriggerSource *)VR {
    if (SDLTriggerSource_VR == nil) {
        SDLTriggerSource_VR = [[SDLTriggerSource alloc] initWithValue:@"VR"];
    }
    return SDLTriggerSource_VR;
}

+ (SDLTriggerSource *)KEYBOARD {
    if (SDLTriggerSource_KEYBOARD == nil) {
        SDLTriggerSource_KEYBOARD = [[SDLTriggerSource alloc] initWithValue:@"KEYBOARD"];
    }
    return SDLTriggerSource_KEYBOARD;
}

@end
