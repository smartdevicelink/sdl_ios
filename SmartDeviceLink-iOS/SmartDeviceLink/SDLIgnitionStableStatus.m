//  SDLIgnitionStableStatus.m
//


#import "SDLIgnitionStableStatus.h"

SDLIgnitionStableStatus *SDLIgnitionStableStatus_IGNITION_SWITCH_NOT_STABLE = nil;
SDLIgnitionStableStatus *SDLIgnitionStableStatus_IGNITION_SWITCH_STABLE = nil;
SDLIgnitionStableStatus *SDLIgnitionStableStatus_MISSING_FROM_TRANSMITTER = nil;

NSArray *SDLIgnitionStableStatus_values = nil;

@implementation SDLIgnitionStableStatus

+ (SDLIgnitionStableStatus *)valueOf:(NSString *)value {
    for (SDLIgnitionStableStatus *item in SDLIgnitionStableStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLIgnitionStableStatus_values == nil) {
        SDLIgnitionStableStatus_values = @[
            SDLIgnitionStableStatus.IGNITION_SWITCH_NOT_STABLE,
            SDLIgnitionStableStatus.IGNITION_SWITCH_STABLE,
            SDLIgnitionStableStatus.MISSING_FROM_TRANSMITTER,
        ];
    }
    return SDLIgnitionStableStatus_values;
}

+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_NOT_STABLE {
    if (SDLIgnitionStableStatus_IGNITION_SWITCH_NOT_STABLE == nil) {
        SDLIgnitionStableStatus_IGNITION_SWITCH_NOT_STABLE = [[SDLIgnitionStableStatus alloc] initWithValue:@"IGNITION_SWITCH_NOT_STABLE"];
    }
    return SDLIgnitionStableStatus_IGNITION_SWITCH_NOT_STABLE;
}

+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_STABLE {
    if (SDLIgnitionStableStatus_IGNITION_SWITCH_STABLE == nil) {
        SDLIgnitionStableStatus_IGNITION_SWITCH_STABLE = [[SDLIgnitionStableStatus alloc] initWithValue:@"IGNITION_SWITCH_STABLE"];
    }
    return SDLIgnitionStableStatus_IGNITION_SWITCH_STABLE;
}

+ (SDLIgnitionStableStatus *)MISSING_FROM_TRANSMITTER {
    if (SDLIgnitionStableStatus_MISSING_FROM_TRANSMITTER == nil) {
        SDLIgnitionStableStatus_MISSING_FROM_TRANSMITTER = [[SDLIgnitionStableStatus alloc] initWithValue:@"MISSING_FROM_TRANSMITTER"];
    }
    return SDLIgnitionStableStatus_MISSING_FROM_TRANSMITTER;
}

@end
