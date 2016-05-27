//  SDLPowerModeStatus.m
//


#import "SDLPowerModeStatus.h"

SDLPowerModeStatus *SDLPowerModeStatus_KEY_OUT = nil;
SDLPowerModeStatus *SDLPowerModeStatus_KEY_RECENTLY_OUT = nil;
SDLPowerModeStatus *SDLPowerModeStatus_KEY_APPROVED_0 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_POST_ACCESORY_0 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_ACCESORY_1 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_POST_IGNITION_1 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_IGNITION_ON_2 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_RUNNING_2 = nil;
SDLPowerModeStatus *SDLPowerModeStatus_CRANK_3 = nil;

NSArray *SDLPowerModeStatus_values = nil;

@implementation SDLPowerModeStatus

+ (SDLPowerModeStatus *)valueOf:(NSString *)value {
    for (SDLPowerModeStatus *item in SDLPowerModeStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPowerModeStatus_values == nil) {
        SDLPowerModeStatus_values = @[
            SDLPowerModeStatus.KEY_OUT,
            SDLPowerModeStatus.KEY_RECENTLY_OUT,
            SDLPowerModeStatus.KEY_APPROVED_0,
            SDLPowerModeStatus.POST_ACCESORY_0,
            SDLPowerModeStatus.ACCESORY_1,
            SDLPowerModeStatus.POST_IGNITION_1,
            SDLPowerModeStatus.IGNITION_ON_2,
            SDLPowerModeStatus.RUNNING_2,
            SDLPowerModeStatus.CRANK_3,
        ];
    }
    return SDLPowerModeStatus_values;
}

+ (SDLPowerModeStatus *)KEY_OUT {
    if (SDLPowerModeStatus_KEY_OUT == nil) {
        SDLPowerModeStatus_KEY_OUT = [[SDLPowerModeStatus alloc] initWithValue:@"KEY_OUT"];
    }
    return SDLPowerModeStatus_KEY_OUT;
}

+ (SDLPowerModeStatus *)KEY_RECENTLY_OUT {
    if (SDLPowerModeStatus_KEY_RECENTLY_OUT == nil) {
        SDLPowerModeStatus_KEY_RECENTLY_OUT = [[SDLPowerModeStatus alloc] initWithValue:@"KEY_RECENTLY_OUT"];
    }
    return SDLPowerModeStatus_KEY_RECENTLY_OUT;
}

+ (SDLPowerModeStatus *)KEY_APPROVED_0 {
    if (SDLPowerModeStatus_KEY_APPROVED_0 == nil) {
        SDLPowerModeStatus_KEY_APPROVED_0 = [[SDLPowerModeStatus alloc] initWithValue:@"KEY_APPROVED_0"];
    }
    return SDLPowerModeStatus_KEY_APPROVED_0;
}

+ (SDLPowerModeStatus *)POST_ACCESORY_0 {
    if (SDLPowerModeStatus_POST_ACCESORY_0 == nil) {
        SDLPowerModeStatus_POST_ACCESORY_0 = [[SDLPowerModeStatus alloc] initWithValue:@"POST_ACCESORY_0"];
    }
    return SDLPowerModeStatus_POST_ACCESORY_0;
}

+ (SDLPowerModeStatus *)ACCESORY_1 {
    if (SDLPowerModeStatus_ACCESORY_1 == nil) {
        SDLPowerModeStatus_ACCESORY_1 = [[SDLPowerModeStatus alloc] initWithValue:@"ACCESORY_1"];
    }
    return SDLPowerModeStatus_ACCESORY_1;
}

+ (SDLPowerModeStatus *)POST_IGNITION_1 {
    if (SDLPowerModeStatus_POST_IGNITION_1 == nil) {
        SDLPowerModeStatus_POST_IGNITION_1 = [[SDLPowerModeStatus alloc] initWithValue:@"POST_IGNITION_1"];
    }
    return SDLPowerModeStatus_POST_IGNITION_1;
}

+ (SDLPowerModeStatus *)IGNITION_ON_2 {
    if (SDLPowerModeStatus_IGNITION_ON_2 == nil) {
        SDLPowerModeStatus_IGNITION_ON_2 = [[SDLPowerModeStatus alloc] initWithValue:@"IGNITION_ON_2"];
    }
    return SDLPowerModeStatus_IGNITION_ON_2;
}

+ (SDLPowerModeStatus *)RUNNING_2 {
    if (SDLPowerModeStatus_RUNNING_2 == nil) {
        SDLPowerModeStatus_RUNNING_2 = [[SDLPowerModeStatus alloc] initWithValue:@"RUNNING_2"];
    }
    return SDLPowerModeStatus_RUNNING_2;
}

+ (SDLPowerModeStatus *)CRANK_3 {
    if (SDLPowerModeStatus_CRANK_3 == nil) {
        SDLPowerModeStatus_CRANK_3 = [[SDLPowerModeStatus alloc] initWithValue:@"CRANK_3"];
    }
    return SDLPowerModeStatus_CRANK_3;
}

@end
