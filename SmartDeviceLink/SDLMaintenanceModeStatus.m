//  SDLMaintenanceModeStatus.m
//


#import "SDLMaintenanceModeStatus.h"

SDLMaintenanceModeStatus *SDLMaintenanceModeStatus_NORMAL = nil;
SDLMaintenanceModeStatus *SDLMaintenanceModeStatus_NEAR = nil;
SDLMaintenanceModeStatus *SDLMaintenanceModeStatus_ACTIVE = nil;
SDLMaintenanceModeStatus *SDLMaintenanceModeStatus_FEATURE_NOT_PRESENT = nil;

NSArray *SDLMaintenanceModeStatus_values = nil;

@implementation SDLMaintenanceModeStatus

+ (SDLMaintenanceModeStatus *)valueOf:(NSString *)value {
    for (SDLMaintenanceModeStatus *item in SDLMaintenanceModeStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLMaintenanceModeStatus_values == nil) {
        SDLMaintenanceModeStatus_values = @[
            SDLMaintenanceModeStatus.NORMAL,
            SDLMaintenanceModeStatus.NEAR,
            SDLMaintenanceModeStatus.ACTIVE,
            SDLMaintenanceModeStatus.FEATURE_NOT_PRESENT,
        ];
    }
    return SDLMaintenanceModeStatus_values;
}

+ (SDLMaintenanceModeStatus *)NORMAL {
    if (SDLMaintenanceModeStatus_NORMAL == nil) {
        SDLMaintenanceModeStatus_NORMAL = [[SDLMaintenanceModeStatus alloc] initWithValue:@"NORMAL"];
    }
    return SDLMaintenanceModeStatus_NORMAL;
}

+ (SDLMaintenanceModeStatus *)NEAR {
    if (SDLMaintenanceModeStatus_NEAR == nil) {
        SDLMaintenanceModeStatus_NEAR = [[SDLMaintenanceModeStatus alloc] initWithValue:@"NEAR"];
    }
    return SDLMaintenanceModeStatus_NEAR;
}

+ (SDLMaintenanceModeStatus *)ACTIVE {
    if (SDLMaintenanceModeStatus_ACTIVE == nil) {
        SDLMaintenanceModeStatus_ACTIVE = [[SDLMaintenanceModeStatus alloc] initWithValue:@"ACTIVE"];
    }
    return SDLMaintenanceModeStatus_ACTIVE;
}

+ (SDLMaintenanceModeStatus *)FEATURE_NOT_PRESENT {
    if (SDLMaintenanceModeStatus_FEATURE_NOT_PRESENT == nil) {
        SDLMaintenanceModeStatus_FEATURE_NOT_PRESENT = [[SDLMaintenanceModeStatus alloc] initWithValue:@"FEATURE_NOT_PRESENT"];
    }
    return SDLMaintenanceModeStatus_FEATURE_NOT_PRESENT;
}

@end
