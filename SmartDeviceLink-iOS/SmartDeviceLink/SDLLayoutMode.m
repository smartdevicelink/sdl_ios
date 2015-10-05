//  SDLLayoutMode.m
//


#import "SDLLayoutMode.h"

SDLLayoutMode *SDLLayoutMode_ICON_ONLY = nil;
SDLLayoutMode *SDLLayoutMode_ICON_WITH_SEARCH = nil;
SDLLayoutMode *SDLLayoutMode_LIST_ONLY = nil;
SDLLayoutMode *SDLLayoutMode_LIST_WITH_SEARCH = nil;
SDLLayoutMode *SDLLayoutMode_KEYBOARD = nil;

NSArray *SDLLayoutMode_values = nil;

@implementation SDLLayoutMode

+ (SDLLayoutMode *)valueOf:(NSString *)value {
    for (SDLLayoutMode *item in SDLLayoutMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLLayoutMode_values == nil) {
        SDLLayoutMode_values = @[
            SDLLayoutMode.ICON_ONLY,
            SDLLayoutMode.ICON_WITH_SEARCH,
            SDLLayoutMode.LIST_ONLY,
            SDLLayoutMode.LIST_WITH_SEARCH,
            SDLLayoutMode.KEYBOARD,
        ];
    }
    return SDLLayoutMode_values;
}

+ (SDLLayoutMode *)ICON_ONLY {
    if (SDLLayoutMode_ICON_ONLY == nil) {
        SDLLayoutMode_ICON_ONLY = [[SDLLayoutMode alloc] initWithValue:@"ICON_ONLY"];
    }
    return SDLLayoutMode_ICON_ONLY;
}

+ (SDLLayoutMode *)ICON_WITH_SEARCH {
    if (SDLLayoutMode_ICON_WITH_SEARCH == nil) {
        SDLLayoutMode_ICON_WITH_SEARCH = [[SDLLayoutMode alloc] initWithValue:@"ICON_WITH_SEARCH"];
    }
    return SDLLayoutMode_ICON_WITH_SEARCH;
}

+ (SDLLayoutMode *)LIST_ONLY {
    if (SDLLayoutMode_LIST_ONLY == nil) {
        SDLLayoutMode_LIST_ONLY = [[SDLLayoutMode alloc] initWithValue:@"LIST_ONLY"];
    }
    return SDLLayoutMode_LIST_ONLY;
}

+ (SDLLayoutMode *)LIST_WITH_SEARCH {
    if (SDLLayoutMode_LIST_WITH_SEARCH == nil) {
        SDLLayoutMode_LIST_WITH_SEARCH = [[SDLLayoutMode alloc] initWithValue:@"LIST_WITH_SEARCH"];
    }
    return SDLLayoutMode_LIST_WITH_SEARCH;
}

+ (SDLLayoutMode *)KEYBOARD {
    if (SDLLayoutMode_KEYBOARD == nil) {
        SDLLayoutMode_KEYBOARD = [[SDLLayoutMode alloc] initWithValue:@"KEYBOARD"];
    }
    return SDLLayoutMode_KEYBOARD;
}

@end
