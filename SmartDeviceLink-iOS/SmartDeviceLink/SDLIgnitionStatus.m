//  SDLIgnitionStatus.m
//


#import "SDLIgnitionStatus.h"

SDLIgnitionStatus *SDLIgnitionStatus_UNKNOWN = nil;
SDLIgnitionStatus *SDLIgnitionStatus_OFF = nil;
SDLIgnitionStatus *SDLIgnitionStatus_ACCESSORY = nil;
SDLIgnitionStatus *SDLIgnitionStatus_RUN = nil;
SDLIgnitionStatus *SDLIgnitionStatus_START = nil;
SDLIgnitionStatus *SDLIgnitionStatus_INVALID = nil;

NSArray *SDLIgnitionStatus_values = nil;

@implementation SDLIgnitionStatus

+ (SDLIgnitionStatus *)valueOf:(NSString *)value {
    for (SDLIgnitionStatus *item in SDLIgnitionStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLIgnitionStatus_values == nil) {
        SDLIgnitionStatus_values = @[
            SDLIgnitionStatus.UNKNOWN,
            SDLIgnitionStatus.OFF,
            SDLIgnitionStatus.ACCESSORY,
            SDLIgnitionStatus.RUN,
            SDLIgnitionStatus.START,
            SDLIgnitionStatus.INVALID,
        ];
    }
    return SDLIgnitionStatus_values;
}

+ (SDLIgnitionStatus *)UNKNOWN {
    if (SDLIgnitionStatus_UNKNOWN == nil) {
        SDLIgnitionStatus_UNKNOWN = [[SDLIgnitionStatus alloc] initWithValue:@"UNKNOWN"];
    }
    return SDLIgnitionStatus_UNKNOWN;
}

+ (SDLIgnitionStatus *)OFF {
    if (SDLIgnitionStatus_OFF == nil) {
        SDLIgnitionStatus_OFF = [[SDLIgnitionStatus alloc] initWithValue:@"OFF"];
    }
    return SDLIgnitionStatus_OFF;
}

+ (SDLIgnitionStatus *)ACCESSORY {
    if (SDLIgnitionStatus_ACCESSORY == nil) {
        SDLIgnitionStatus_ACCESSORY = [[SDLIgnitionStatus alloc] initWithValue:@"ACCESSORY"];
    }
    return SDLIgnitionStatus_ACCESSORY;
}

+ (SDLIgnitionStatus *)RUN {
    if (SDLIgnitionStatus_RUN == nil) {
        SDLIgnitionStatus_RUN = [[SDLIgnitionStatus alloc] initWithValue:@"RUN"];
    }
    return SDLIgnitionStatus_RUN;
}

+ (SDLIgnitionStatus *)START {
    if (SDLIgnitionStatus_START == nil) {
        SDLIgnitionStatus_START = [[SDLIgnitionStatus alloc] initWithValue:@"START"];
    }
    return SDLIgnitionStatus_START;
}

+ (SDLIgnitionStatus *)INVALID {
    if (SDLIgnitionStatus_INVALID == nil) {
        SDLIgnitionStatus_INVALID = [[SDLIgnitionStatus alloc] initWithValue:@"INVALID"];
    }
    return SDLIgnitionStatus_INVALID;
}

@end
