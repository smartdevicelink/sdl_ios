//  SDLPredefinedLayout.m
//


#import "SDLPredefinedLayout.h"

SDLPredefinedLayout *SDLPredefinedLayout_DEFAULT = nil;
SDLPredefinedLayout *SDLPredefinedLayout_MEDIA = nil;
SDLPredefinedLayout *SDLPredefinedLayout_NON_MEDIA = nil;
SDLPredefinedLayout *SDLPredefinedLayout_ONSCREEN_PRESETS = nil;
SDLPredefinedLayout *SDLPredefinedLayout_NAV_FULLSCREEN_MAP = nil;
SDLPredefinedLayout *SDLPredefinedLayout_NAV_LIST = nil;
SDLPredefinedLayout *SDLPredefinedLayout_NAV_KEYBOARD = nil;
SDLPredefinedLayout *SDLPredefinedLayout_GRAPHIC_WITH_TEXT = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TEXT_WITH_GRAPHIC = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TILES_ONLY = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TEXTBUTTONS_ONLY = nil;
SDLPredefinedLayout *SDLPredefinedLayout_GRAPHIC_WITH_TILES = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TILES_WITH_GRAPHIC = nil;
SDLPredefinedLayout *SDLPredefinedLayout_GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC = nil;
SDLPredefinedLayout *SDLPredefinedLayout_GRAPHIC_WITH_TEXTBUTTONS = nil;
SDLPredefinedLayout *SDLPredefinedLayout_TEXTBUTTONS_WITH_GRAPHIC = nil;
SDLPredefinedLayout *SDLPredefinedLayout_LARGE_GRAPHIC_WITH_SOFTBUTTONS = nil;
SDLPredefinedLayout *SDLPredefinedLayout_DOUBLE_GRAPHIC_WITH_SOFTBUTTONS = nil;
SDLPredefinedLayout *SDLPredefinedLayout_LARGE_GRAPHIC_ONLY = nil;

NSArray *SDLPredefinedLayout_values = nil;

@implementation SDLPredefinedLayout

+ (SDLPredefinedLayout *)valueOf:(NSString *)value {
    for (SDLPredefinedLayout *item in SDLPredefinedLayout.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPredefinedLayout_values == nil) {
        SDLPredefinedLayout_values = @[
            SDLPredefinedLayout.DEFAULT,
            SDLPredefinedLayout.MEDIA,
            SDLPredefinedLayout.NON_MEDIA,
            SDLPredefinedLayout.ONSCREEN_PRESETS,
            SDLPredefinedLayout.NAV_FULLSCREEN_MAP,
            SDLPredefinedLayout.NAV_LIST,
            SDLPredefinedLayout.NAV_KEYBOARD,
            SDLPredefinedLayout.GRAPHIC_WITH_TEXT,
            SDLPredefinedLayout.TEXT_WITH_GRAPHIC,
            SDLPredefinedLayout.TILES_ONLY,
            SDLPredefinedLayout.TEXTBUTTONS_ONLY,
            SDLPredefinedLayout.GRAPHIC_WITH_TILES,
            SDLPredefinedLayout.TILES_WITH_GRAPHIC,
            SDLPredefinedLayout.GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS,
            SDLPredefinedLayout.TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC,
            SDLPredefinedLayout.GRAPHIC_WITH_TEXTBUTTONS,
            SDLPredefinedLayout.TEXTBUTTONS_WITH_GRAPHIC,
            SDLPredefinedLayout.LARGE_GRAPHIC_WITH_SOFTBUTTONS,
            SDLPredefinedLayout.DOUBLE_GRAPHIC_WITH_SOFTBUTTONS,
            SDLPredefinedLayout.LARGE_GRAPHIC_ONLY,
        ];
    }
    return SDLPredefinedLayout_values;
}

+ (SDLPredefinedLayout *)DEFAULT {
    if (SDLPredefinedLayout_DEFAULT == nil) {
        SDLPredefinedLayout_DEFAULT = [[SDLPredefinedLayout alloc] initWithValue:@"DEFAULT"];
    }
    return SDLPredefinedLayout_DEFAULT;
}

+ (SDLPredefinedLayout *)MEDIA {
    if (SDLPredefinedLayout_MEDIA == nil) {
        SDLPredefinedLayout_MEDIA = [[SDLPredefinedLayout alloc] initWithValue:@"MEDIA"];
    }
    return SDLPredefinedLayout_MEDIA;
}

+ (SDLPredefinedLayout *)NON_MEDIA {
    if (SDLPredefinedLayout_NON_MEDIA == nil) {
        SDLPredefinedLayout_NON_MEDIA = [[SDLPredefinedLayout alloc] initWithValue:@"NON-MEDIA"];
    }
    return SDLPredefinedLayout_NON_MEDIA;
}

+ (SDLPredefinedLayout *)ONSCREEN_PRESETS {
    if (SDLPredefinedLayout_ONSCREEN_PRESETS == nil) {
        SDLPredefinedLayout_ONSCREEN_PRESETS = [[SDLPredefinedLayout alloc] initWithValue:@"ONSCREEN_PRESETS"];
    }
    return SDLPredefinedLayout_ONSCREEN_PRESETS;
}

+ (SDLPredefinedLayout *)NAV_FULLSCREEN_MAP {
    if (SDLPredefinedLayout_NAV_FULLSCREEN_MAP == nil) {
        SDLPredefinedLayout_NAV_FULLSCREEN_MAP = [[SDLPredefinedLayout alloc] initWithValue:@"NAV_FULLSCREEN_MAP"];
    }
    return SDLPredefinedLayout_NAV_FULLSCREEN_MAP;
}

+ (SDLPredefinedLayout *)NAV_LIST {
    if (SDLPredefinedLayout_NAV_LIST == nil) {
        SDLPredefinedLayout_NAV_LIST = [[SDLPredefinedLayout alloc] initWithValue:@"NAV_LIST"];
    }
    return SDLPredefinedLayout_NAV_LIST;
}

+ (SDLPredefinedLayout *)NAV_KEYBOARD {
    if (SDLPredefinedLayout_NAV_KEYBOARD == nil) {
        SDLPredefinedLayout_NAV_KEYBOARD = [[SDLPredefinedLayout alloc] initWithValue:@"NAV_KEYBOARD"];
    }
    return SDLPredefinedLayout_NAV_KEYBOARD;
}

+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXT {
    if (SDLPredefinedLayout_GRAPHIC_WITH_TEXT == nil) {
        SDLPredefinedLayout_GRAPHIC_WITH_TEXT = [[SDLPredefinedLayout alloc] initWithValue:@"GRAPHIC_WITH_TEXT"];
    }
    return SDLPredefinedLayout_GRAPHIC_WITH_TEXT;
}

+ (SDLPredefinedLayout *)TEXT_WITH_GRAPHIC {
    if (SDLPredefinedLayout_TEXT_WITH_GRAPHIC == nil) {
        SDLPredefinedLayout_TEXT_WITH_GRAPHIC = [[SDLPredefinedLayout alloc] initWithValue:@"TEXT_WITH_GRAPHIC"];
    }
    return SDLPredefinedLayout_TEXT_WITH_GRAPHIC;
}

+ (SDLPredefinedLayout *)TILES_ONLY {
    if (SDLPredefinedLayout_TILES_ONLY == nil) {
        SDLPredefinedLayout_TILES_ONLY = [[SDLPredefinedLayout alloc] initWithValue:@"TILES_ONLY"];
    }
    return SDLPredefinedLayout_TILES_ONLY;
}

+ (SDLPredefinedLayout *)TEXTBUTTONS_ONLY {
    if (SDLPredefinedLayout_TEXTBUTTONS_ONLY == nil) {
        SDLPredefinedLayout_TEXTBUTTONS_ONLY = [[SDLPredefinedLayout alloc] initWithValue:@"TEXTBUTTONS_ONLY"];
    }
    return SDLPredefinedLayout_TEXTBUTTONS_ONLY;
}

+ (SDLPredefinedLayout *)GRAPHIC_WITH_TILES {
    if (SDLPredefinedLayout_GRAPHIC_WITH_TILES == nil) {
        SDLPredefinedLayout_GRAPHIC_WITH_TILES = [[SDLPredefinedLayout alloc] initWithValue:@"GRAPHIC_WITH_TILES"];
    }
    return SDLPredefinedLayout_GRAPHIC_WITH_TILES;
}

+ (SDLPredefinedLayout *)TILES_WITH_GRAPHIC {
    if (SDLPredefinedLayout_TILES_WITH_GRAPHIC == nil) {
        SDLPredefinedLayout_TILES_WITH_GRAPHIC = [[SDLPredefinedLayout alloc] initWithValue:@"TILES_WITH_GRAPHIC"];
    }
    return SDLPredefinedLayout_TILES_WITH_GRAPHIC;
}

+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS {
    if (SDLPredefinedLayout_GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS == nil) {
        SDLPredefinedLayout_GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS = [[SDLPredefinedLayout alloc] initWithValue:@"GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS"];
    }
    return SDLPredefinedLayout_GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS;
}

+ (SDLPredefinedLayout *)TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC {
    if (SDLPredefinedLayout_TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC == nil) {
        SDLPredefinedLayout_TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC = [[SDLPredefinedLayout alloc] initWithValue:@"TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC"];
    }
    return SDLPredefinedLayout_TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC;
}

+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXTBUTTONS {
    if (SDLPredefinedLayout_GRAPHIC_WITH_TEXTBUTTONS == nil) {
        SDLPredefinedLayout_GRAPHIC_WITH_TEXTBUTTONS = [[SDLPredefinedLayout alloc] initWithValue:@"GRAPHIC_WITH_TEXTBUTTONS"];
    }
    return SDLPredefinedLayout_GRAPHIC_WITH_TEXTBUTTONS;
}

+ (SDLPredefinedLayout *)TEXTBUTTONS_WITH_GRAPHIC {
    if (SDLPredefinedLayout_TEXTBUTTONS_WITH_GRAPHIC == nil) {
        SDLPredefinedLayout_TEXTBUTTONS_WITH_GRAPHIC = [[SDLPredefinedLayout alloc] initWithValue:@"TEXTBUTTONS_WITH_GRAPHIC"];
    }
    return SDLPredefinedLayout_TEXTBUTTONS_WITH_GRAPHIC;
}

+ (SDLPredefinedLayout *)LARGE_GRAPHIC_WITH_SOFTBUTTONS {
    if (SDLPredefinedLayout_LARGE_GRAPHIC_WITH_SOFTBUTTONS == nil) {
        SDLPredefinedLayout_LARGE_GRAPHIC_WITH_SOFTBUTTONS = [[SDLPredefinedLayout alloc] initWithValue:@"LARGE_GRAPHIC_WITH_SOFTBUTTONS"];
    }
    return SDLPredefinedLayout_LARGE_GRAPHIC_WITH_SOFTBUTTONS;
}

+ (SDLPredefinedLayout *)DOUBLE_GRAPHIC_WITH_SOFTBUTTONS {
    if (SDLPredefinedLayout_DOUBLE_GRAPHIC_WITH_SOFTBUTTONS == nil) {
        SDLPredefinedLayout_DOUBLE_GRAPHIC_WITH_SOFTBUTTONS = [[SDLPredefinedLayout alloc] initWithValue:@"DOUBLE_GRAPHIC_WITH_SOFTBUTTONS"];
    }
    return SDLPredefinedLayout_DOUBLE_GRAPHIC_WITH_SOFTBUTTONS;
}

+ (SDLPredefinedLayout *)LARGE_GRAPHIC_ONLY {
    if (SDLPredefinedLayout_LARGE_GRAPHIC_ONLY == nil) {
        SDLPredefinedLayout_LARGE_GRAPHIC_ONLY = [[SDLPredefinedLayout alloc] initWithValue:@"LARGE_GRAPHIC_ONLY"];
    }
    return SDLPredefinedLayout_LARGE_GRAPHIC_ONLY;
}

@end
