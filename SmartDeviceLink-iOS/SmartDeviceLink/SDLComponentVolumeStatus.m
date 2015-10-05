//  SDLComponentVolumeStatus.m
//


#import "SDLComponentVolumeStatus.h"

SDLComponentVolumeStatus *SDLComponentVolumeStatus_UNKNOWN = nil;
SDLComponentVolumeStatus *SDLComponentVolumeStatus_NORMAL = nil;
SDLComponentVolumeStatus *SDLComponentVolumeStatus_LOW = nil;
SDLComponentVolumeStatus *SDLComponentVolumeStatus_FAULT = nil;
SDLComponentVolumeStatus *SDLComponentVolumeStatus_ALERT = nil;
SDLComponentVolumeStatus *SDLComponentVolumeStatus_NOT_SUPPORTED = nil;

NSArray *SDLComponentVolumeStatus_values = nil;

@implementation SDLComponentVolumeStatus

+ (SDLComponentVolumeStatus *)valueOf:(NSString *)value {
    for (SDLComponentVolumeStatus *item in SDLComponentVolumeStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLComponentVolumeStatus_values == nil) {
        SDLComponentVolumeStatus_values = @[
            SDLComponentVolumeStatus.UNKNOWN,
            SDLComponentVolumeStatus.NORMAL,
            SDLComponentVolumeStatus.LOW,
            SDLComponentVolumeStatus.FAULT,
            SDLComponentVolumeStatus.ALERT,
            SDLComponentVolumeStatus.NOT_SUPPORTED,
        ];
    }
    return SDLComponentVolumeStatus_values;
}

+ (SDLComponentVolumeStatus *)UNKNOWN {
    if (SDLComponentVolumeStatus_UNKNOWN == nil) {
        SDLComponentVolumeStatus_UNKNOWN = [[SDLComponentVolumeStatus alloc] initWithValue:@"UNKNOWN"];
    }
    return SDLComponentVolumeStatus_UNKNOWN;
}

+ (SDLComponentVolumeStatus *)NORMAL {
    if (SDLComponentVolumeStatus_NORMAL == nil) {
        SDLComponentVolumeStatus_NORMAL = [[SDLComponentVolumeStatus alloc] initWithValue:@"NORMAL"];
    }
    return SDLComponentVolumeStatus_NORMAL;
}

+ (SDLComponentVolumeStatus *)LOW {
    if (SDLComponentVolumeStatus_LOW == nil) {
        SDLComponentVolumeStatus_LOW = [[SDLComponentVolumeStatus alloc] initWithValue:@"LOW"];
    }
    return SDLComponentVolumeStatus_LOW;
}

+ (SDLComponentVolumeStatus *)FAULT {
    if (SDLComponentVolumeStatus_FAULT == nil) {
        SDLComponentVolumeStatus_FAULT = [[SDLComponentVolumeStatus alloc] initWithValue:@"FAULT"];
    }
    return SDLComponentVolumeStatus_FAULT;
}

+ (SDLComponentVolumeStatus *)ALERT {
    if (SDLComponentVolumeStatus_ALERT == nil) {
        SDLComponentVolumeStatus_ALERT = [[SDLComponentVolumeStatus alloc] initWithValue:@"ALERT"];
    }
    return SDLComponentVolumeStatus_ALERT;
}

+ (SDLComponentVolumeStatus *)NOT_SUPPORTED {
    if (SDLComponentVolumeStatus_NOT_SUPPORTED == nil) {
        SDLComponentVolumeStatus_NOT_SUPPORTED = [[SDLComponentVolumeStatus alloc] initWithValue:@"NOT_SUPPORTED"];
    }
    return SDLComponentVolumeStatus_NOT_SUPPORTED;
}

@end
