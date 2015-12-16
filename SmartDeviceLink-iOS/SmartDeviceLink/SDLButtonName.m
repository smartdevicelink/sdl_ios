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

SDLButtonName *SDLButtonName_AC_MAX = nil;
SDLButtonName *SDLButtonName_AC = nil;
SDLButtonName *SDLButtonName_RECIRCULATE = nil;
SDLButtonName *SDLButtonName_FAN_UP = nil;
SDLButtonName *SDLButtonName_FAN_DOWN = nil;
SDLButtonName *SDLButtonName_TEMP_UP = nil;
SDLButtonName *SDLButtonName_TEMP_DOWN = nil;
SDLButtonName *SDLButtonName_DEFROST_MAX = nil;
SDLButtonName *SDLButtonName_DEFROST = nil;
SDLButtonName *SDLButtonName_DEFROST_REAR = nil;
SDLButtonName *SDLButtonName_UPPER_VENT = nil;
SDLButtonName *SDLButtonName_LOWER_VENT = nil;

SDLButtonName *SDLButtonName_VOLUME_UP = nil;
SDLButtonName *SDLButtonName_VOLUME_DOWN = nil;
SDLButtonName *SDLButtonName_EJECT = nil;
SDLButtonName *SDLButtonName_SOURCE = nil;
SDLButtonName *SDLButtonName_SHUFFLE = nil;
SDLButtonName *SDLButtonName_REPEAT = nil;

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
            [SDLButtonName OK],
            [SDLButtonName SEEKLEFT],
            [SDLButtonName SEEKRIGHT],
            [SDLButtonName TUNEUP],
            [SDLButtonName TUNEDOWN],
            [SDLButtonName PRESET_0],
            [SDLButtonName PRESET_1],
            [SDLButtonName PRESET_2],
            [SDLButtonName PRESET_3],
            [SDLButtonName PRESET_4],
            [SDLButtonName PRESET_5],
            [SDLButtonName PRESET_6],
            [SDLButtonName PRESET_7],
            [SDLButtonName PRESET_8],
            [SDLButtonName PRESET_9],
            [SDLButtonName CUSTOM_BUTTON],
            [SDLButtonName SEARCH],
            [SDLButtonName AC_MAX],
            [SDLButtonName AC],
            [SDLButtonName RECIRCULATE],
            [SDLButtonName FAN_UP],
            [SDLButtonName FAN_DOWN],
            [SDLButtonName TEMP_UP],
            [SDLButtonName TEMP_DOWN],
            [SDLButtonName DEFROST_MAX],
            [SDLButtonName DEFROST],
            [SDLButtonName DEFROST_REAR],
            [SDLButtonName UPPER_VENT],
            [SDLButtonName LOWER_VENT],
            [SDLButtonName VOLUME_UP],
            [SDLButtonName VOLUME_DOWN],
            [SDLButtonName EJECT],
            [SDLButtonName SOURCE],
            [SDLButtonName SHUFFLE],
            [SDLButtonName REPEAT],
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


#pragma MARK - Climate

+ (SDLButtonName *)AC_MAX {
    if (SDLButtonName_AC_MAX == nil) {
        SDLButtonName_AC_MAX = [[SDLButtonName alloc] initWithValue:@"AC_MAX"];
    }
    return SDLButtonName_AC_MAX;
}

+ (SDLButtonName *)AC {
    if (SDLButtonName_AC == nil) {
        SDLButtonName_AC = [[SDLButtonName alloc] initWithValue:@"AC"];
    }
    return SDLButtonName_AC;
}

+ (SDLButtonName *)RECIRCULATE {
    if (SDLButtonName_RECIRCULATE == nil) {
        SDLButtonName_RECIRCULATE = [[SDLButtonName alloc] initWithValue:@"RECIRCULATE"];
    }
    return SDLButtonName_RECIRCULATE;
}

+ (SDLButtonName *)FAN_UP {
    if (SDLButtonName_FAN_UP == nil) {
        SDLButtonName_FAN_UP = [[SDLButtonName alloc] initWithValue:@"FAN_UP"];
    }
    return SDLButtonName_FAN_UP;
}

+ (SDLButtonName *)FAN_DOWN {
    if (SDLButtonName_FAN_DOWN == nil) {
        SDLButtonName_FAN_DOWN = [[SDLButtonName alloc] initWithValue:@"FAN_DOWN"];
    }
    return SDLButtonName_FAN_DOWN;
}

+ (SDLButtonName *)TEMP_UP {
    if (SDLButtonName_TEMP_UP == nil) {
        SDLButtonName_TEMP_UP = [[SDLButtonName alloc] initWithValue:@"TEMP_UP"];
    }
    return SDLButtonName_TEMP_UP;
}

+ (SDLButtonName *)TEMP_DOWN {
    if (SDLButtonName_TEMP_DOWN == nil) {
        SDLButtonName_TEMP_DOWN = [[SDLButtonName alloc] initWithValue:@"TEMP_DOWN"];
    }
    return SDLButtonName_TEMP_DOWN;
}

+ (SDLButtonName *)DEFROST_MAX {
    if (SDLButtonName_DEFROST_MAX == nil) {
        SDLButtonName_DEFROST_MAX = [[SDLButtonName alloc] initWithValue:@"DEFROST_MAX"];
    }
    return SDLButtonName_DEFROST_MAX;
}

+ (SDLButtonName *)DEFROST {
    if (SDLButtonName_DEFROST == nil) {
        SDLButtonName_DEFROST = [[SDLButtonName alloc] initWithValue:@"DEFROST"];
    }
    return SDLButtonName_DEFROST;
}

+ (SDLButtonName *)DEFROST_REAR {
    if (SDLButtonName_DEFROST_REAR == nil) {
        SDLButtonName_DEFROST_REAR = [[SDLButtonName alloc] initWithValue:@"DEFROST_REAR"];
    }
    return SDLButtonName_DEFROST_REAR;
}

+ (SDLButtonName *)UPPER_VENT {
    if (SDLButtonName_UPPER_VENT == nil) {
        SDLButtonName_UPPER_VENT = [[SDLButtonName alloc] initWithValue:@"UPPER_VENT"];
    }
    return SDLButtonName_UPPER_VENT;
}

+ (SDLButtonName *)LOWER_VENT {
    if (SDLButtonName_LOWER_VENT == nil) {
        SDLButtonName_LOWER_VENT = [[SDLButtonName alloc] initWithValue:@"LOWER_VENT"];
    }
    return SDLButtonName_LOWER_VENT;
}


#pragma mark - Radio

+ (SDLButtonName *)VOLUME_UP {
    if (SDLButtonName_VOLUME_UP == nil) {
        SDLButtonName_VOLUME_UP = [[SDLButtonName alloc] initWithValue:@"VOLUME_UP"];
    }
    return SDLButtonName_VOLUME_UP;
}

+ (SDLButtonName *)VOLUME_DOWN {
    if (SDLButtonName_VOLUME_DOWN == nil) {
        SDLButtonName_VOLUME_DOWN = [[SDLButtonName alloc] initWithValue:@"VOLUME_DOWN"];
    }
    return SDLButtonName_VOLUME_DOWN;
}

+ (SDLButtonName *)EJECT {
    if (SDLButtonName_EJECT == nil) {
        SDLButtonName_EJECT = [[SDLButtonName alloc] initWithValue:@"EJECT"];
    }
    return SDLButtonName_EJECT;
}

+ (SDLButtonName *)SOURCE {
    if (SDLButtonName_SOURCE == nil) {
        SDLButtonName_SOURCE = [[SDLButtonName alloc] initWithValue:@"SOURCE"];
    }
    return SDLButtonName_SOURCE;
}

+ (SDLButtonName *)SHUFFLE {
    if (SDLButtonName_SHUFFLE == nil) {
        SDLButtonName_SHUFFLE = [[SDLButtonName alloc] initWithValue:@"SHUFFLE"];
    }
    return SDLButtonName_SHUFFLE;
}

+ (SDLButtonName *)REPEAT {
    if (SDLButtonName_REPEAT == nil) {
        SDLButtonName_REPEAT = [[SDLButtonName alloc] initWithValue:@"REPEAT"];
    }
    return SDLButtonName_REPEAT;
}

@end
