//  SDLAmbientLightStatus.m
//

#import "SDLAmbientLightStatus.h"

SDLAmbientLightStatus *SDLAmbientLightStatus_NIGHT = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_TWILIGHT_1 = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_TWILIGHT_2 = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_TWILIGHT_3 = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_TWILIGHT_4 = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_DAY = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_UNKNOWN = nil;
SDLAmbientLightStatus *SDLAmbientLightStatus_INVALID = nil;

NSArray *SDLAmbientLightStatus_values = nil;

@implementation SDLAmbientLightStatus

+ (SDLAmbientLightStatus *)valueOf:(NSString *)value {
    for (SDLAmbientLightStatus *item in SDLAmbientLightStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLAmbientLightStatus_values == nil) {
        SDLAmbientLightStatus_values = @[
            SDLAmbientLightStatus.NIGHT,
            SDLAmbientLightStatus.TWILIGHT_1,
            SDLAmbientLightStatus.TWILIGHT_2,
            SDLAmbientLightStatus.TWILIGHT_3,
            SDLAmbientLightStatus.TWILIGHT_4,
            SDLAmbientLightStatus.DAY,
            SDLAmbientLightStatus.UNKNOWN,
            SDLAmbientLightStatus.INVALID,
        ];
    }
    return SDLAmbientLightStatus_values;
}

+ (SDLAmbientLightStatus *)NIGHT {
    if (SDLAmbientLightStatus_NIGHT == nil) {
        SDLAmbientLightStatus_NIGHT = [[SDLAmbientLightStatus alloc] initWithValue:@"NIGHT"];
    }
    return SDLAmbientLightStatus_NIGHT;
}

+ (SDLAmbientLightStatus *)TWILIGHT_1 {
    if (SDLAmbientLightStatus_TWILIGHT_1 == nil) {
        SDLAmbientLightStatus_TWILIGHT_1 = [[SDLAmbientLightStatus alloc] initWithValue:@"TWILIGHT_1"];
    }
    return SDLAmbientLightStatus_TWILIGHT_1;
}

+ (SDLAmbientLightStatus *)TWILIGHT_2 {
    if (SDLAmbientLightStatus_TWILIGHT_2 == nil) {
        SDLAmbientLightStatus_TWILIGHT_2 = [[SDLAmbientLightStatus alloc] initWithValue:@"TWILIGHT_2"];
    }
    return SDLAmbientLightStatus_TWILIGHT_2;
}

+ (SDLAmbientLightStatus *)TWILIGHT_3 {
    if (SDLAmbientLightStatus_TWILIGHT_3 == nil) {
        SDLAmbientLightStatus_TWILIGHT_3 = [[SDLAmbientLightStatus alloc] initWithValue:@"TWILIGHT_3"];
    }
    return SDLAmbientLightStatus_TWILIGHT_3;
}

+ (SDLAmbientLightStatus *)TWILIGHT_4 {
    if (SDLAmbientLightStatus_TWILIGHT_4 == nil) {
        SDLAmbientLightStatus_TWILIGHT_4 = [[SDLAmbientLightStatus alloc] initWithValue:@"TWILIGHT_4"];
    }
    return SDLAmbientLightStatus_TWILIGHT_4;
}

+ (SDLAmbientLightStatus *)DAY {
    if (SDLAmbientLightStatus_DAY == nil) {
        SDLAmbientLightStatus_DAY = [[SDLAmbientLightStatus alloc] initWithValue:@"DAY"];
    }
    return SDLAmbientLightStatus_DAY;
}

+ (SDLAmbientLightStatus *)UNKNOWN {
    if (SDLAmbientLightStatus_UNKNOWN == nil) {
        SDLAmbientLightStatus_UNKNOWN = [[SDLAmbientLightStatus alloc] initWithValue:@"UNKNOWN"];
    }
    return SDLAmbientLightStatus_UNKNOWN;
}

+ (SDLAmbientLightStatus *)INVALID {
    if (SDLAmbientLightStatus_INVALID == nil) {
        SDLAmbientLightStatus_INVALID = [[SDLAmbientLightStatus alloc] initWithValue:@"INVALID"];
    }
    return SDLAmbientLightStatus_INVALID;
}

@end
