//  SDLButtonName.m
//


#import "SDLButtonName.h"

SDLButtonName *SDLButtonName_OK = nil;
SDLButtonName *SDLButtonName_SEEKLEFT = nil;
SDLButtonName *SDLButtonName_SEEKRIGHT = nil;
SDLButtonName *SDLButtonName_TUNEUP = nil;
SDLButtonName *SDLButtonName_TUNEDOWN = nil;
SDLButtonName *SDLButtonName_PRESET_0 = nil;
SDLButtonName *SDLButtonName_PRESET_1 = nil;
SDLButtonName *SDLButtonName_PRESET_2 = nil;
SDLButtonName *SDLButtonName_PRESET_3 = nil;
SDLButtonName *SDLButtonName_PRESET_4 = nil;
SDLButtonName *SDLButtonName_PRESET_5 = nil;
SDLButtonName *SDLButtonName_PRESET_6 = nil;
SDLButtonName *SDLButtonName_PRESET_7 = nil;
SDLButtonName *SDLButtonName_PRESET_8 = nil;
SDLButtonName *SDLButtonName_PRESET_9 = nil;
SDLButtonName *SDLButtonName_CUSTOM_BUTTON = nil;
SDLButtonName *SDLButtonName_SEARCH = nil;

NSArray *SDLButtonName_values = nil;

@implementation SDLButtonName

+ (SDLButtonName *)valueOf:(NSString *)value {
    for (SDLButtonName *item in SDLButtonName.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLButtonName_values == nil) {
        SDLButtonName_values = @[
            SDLButtonName.OK,
            SDLButtonName.SEEKLEFT,
            SDLButtonName.SEEKRIGHT,
            SDLButtonName.TUNEUP,
            SDLButtonName.TUNEDOWN,
            SDLButtonName.PRESET_0,
            SDLButtonName.PRESET_1,
            SDLButtonName.PRESET_2,
            SDLButtonName.PRESET_3,
            SDLButtonName.PRESET_4,
            SDLButtonName.PRESET_5,
            SDLButtonName.PRESET_6,
            SDLButtonName.PRESET_7,
            SDLButtonName.PRESET_8,
            SDLButtonName.PRESET_9,
            SDLButtonName.CUSTOM_BUTTON,
            SDLButtonName.SEARCH,
        ];
    }
    return SDLButtonName_values;
}

+ (SDLButtonName *)OK {
    if (SDLButtonName_OK == nil) {
        SDLButtonName_OK = [[SDLButtonName alloc] initWithValue:@"OK"];
    }
    return SDLButtonName_OK;
}

+ (SDLButtonName *)SEEKLEFT {
    if (SDLButtonName_SEEKLEFT == nil) {
        SDLButtonName_SEEKLEFT = [[SDLButtonName alloc] initWithValue:@"SEEKLEFT"];
    }
    return SDLButtonName_SEEKLEFT;
}

+ (SDLButtonName *)SEEKRIGHT {
    if (SDLButtonName_SEEKRIGHT == nil) {
        SDLButtonName_SEEKRIGHT = [[SDLButtonName alloc] initWithValue:@"SEEKRIGHT"];
    }
    return SDLButtonName_SEEKRIGHT;
}

+ (SDLButtonName *)TUNEUP {
    if (SDLButtonName_TUNEUP == nil) {
        SDLButtonName_TUNEUP = [[SDLButtonName alloc] initWithValue:@"TUNEUP"];
    }
    return SDLButtonName_TUNEUP;
}

+ (SDLButtonName *)TUNEDOWN {
    if (SDLButtonName_TUNEDOWN == nil) {
        SDLButtonName_TUNEDOWN = [[SDLButtonName alloc] initWithValue:@"TUNEDOWN"];
    }
    return SDLButtonName_TUNEDOWN;
}

+ (SDLButtonName *)PRESET_0 {
    if (SDLButtonName_PRESET_0 == nil) {
        SDLButtonName_PRESET_0 = [[SDLButtonName alloc] initWithValue:@"PRESET_0"];
    }
    return SDLButtonName_PRESET_0;
}

+ (SDLButtonName *)PRESET_1 {
    if (SDLButtonName_PRESET_1 == nil) {
        SDLButtonName_PRESET_1 = [[SDLButtonName alloc] initWithValue:@"PRESET_1"];
    }
    return SDLButtonName_PRESET_1;
}

+ (SDLButtonName *)PRESET_2 {
    if (SDLButtonName_PRESET_2 == nil) {
        SDLButtonName_PRESET_2 = [[SDLButtonName alloc] initWithValue:@"PRESET_2"];
    }
    return SDLButtonName_PRESET_2;
}

+ (SDLButtonName *)PRESET_3 {
    if (SDLButtonName_PRESET_3 == nil) {
        SDLButtonName_PRESET_3 = [[SDLButtonName alloc] initWithValue:@"PRESET_3"];
    }
    return SDLButtonName_PRESET_3;
}

+ (SDLButtonName *)PRESET_4 {
    if (SDLButtonName_PRESET_4 == nil) {
        SDLButtonName_PRESET_4 = [[SDLButtonName alloc] initWithValue:@"PRESET_4"];
    }
    return SDLButtonName_PRESET_4;
}

+ (SDLButtonName *)PRESET_5 {
    if (SDLButtonName_PRESET_5 == nil) {
        SDLButtonName_PRESET_5 = [[SDLButtonName alloc] initWithValue:@"PRESET_5"];
    }
    return SDLButtonName_PRESET_5;
}

+ (SDLButtonName *)PRESET_6 {
    if (SDLButtonName_PRESET_6 == nil) {
        SDLButtonName_PRESET_6 = [[SDLButtonName alloc] initWithValue:@"PRESET_6"];
    }
    return SDLButtonName_PRESET_6;
}

+ (SDLButtonName *)PRESET_7 {
    if (SDLButtonName_PRESET_7 == nil) {
        SDLButtonName_PRESET_7 = [[SDLButtonName alloc] initWithValue:@"PRESET_7"];
    }
    return SDLButtonName_PRESET_7;
}

+ (SDLButtonName *)PRESET_8 {
    if (SDLButtonName_PRESET_8 == nil) {
        SDLButtonName_PRESET_8 = [[SDLButtonName alloc] initWithValue:@"PRESET_8"];
    }
    return SDLButtonName_PRESET_8;
}

+ (SDLButtonName *)PRESET_9 {
    if (SDLButtonName_PRESET_9 == nil) {
        SDLButtonName_PRESET_9 = [[SDLButtonName alloc] initWithValue:@"PRESET_9"];
    }
    return SDLButtonName_PRESET_9;
}

+ (SDLButtonName *)CUSTOM_BUTTON {
    if (SDLButtonName_CUSTOM_BUTTON == nil) {
        SDLButtonName_CUSTOM_BUTTON = [[SDLButtonName alloc] initWithValue:@"CUSTOM_BUTTON"];
    }
    return SDLButtonName_CUSTOM_BUTTON;
}

+ (SDLButtonName *)SEARCH {
    if (SDLButtonName_SEARCH == nil) {
        SDLButtonName_SEARCH = [[SDLButtonName alloc] initWithValue:@"SEARCH"];
    }
    return SDLButtonName_SEARCH;
}

@end
