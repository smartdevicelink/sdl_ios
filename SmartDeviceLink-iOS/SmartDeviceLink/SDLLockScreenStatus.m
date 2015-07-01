//
//  SDLLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatus.h"

@implementation SDLLockScreenStatus

SDLLockScreenStatus *SDLLockScreenStatus_OFF = nil;
SDLLockScreenStatus *SDLLockScreenStatus_OPTIONAL = nil;
SDLLockScreenStatus *SDLLockScreenStatus_REQUIRED = nil;

NSArray *SDLLockScreenStatus_values = nil;


+ (SDLLockScreenStatus *)valueOf:(NSString *)value {
    for (SDLLockScreenStatus *item in SDLLockScreenStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLLockScreenStatus_values == nil) {
        SDLLockScreenStatus_values = @[
            SDLLockScreenStatus.OFF,
            SDLLockScreenStatus.OPTIONAL,
            SDLLockScreenStatus.REQUIRED,
        ];
    }
    return SDLLockScreenStatus_values;
}

+ (SDLLockScreenStatus *)OFF {
    if (SDLLockScreenStatus_OFF == nil) {
        SDLLockScreenStatus_OFF = [[SDLLockScreenStatus alloc] initWithValue:@"OFF"];
    }
    return SDLLockScreenStatus_OFF;
}

+ (SDLLockScreenStatus *)OPTIONAL {
    if (SDLLockScreenStatus_OPTIONAL == nil) {
        SDLLockScreenStatus_OPTIONAL = [[SDLLockScreenStatus alloc] initWithValue:@"OPTIONAL"];
    }
    return SDLLockScreenStatus_OPTIONAL;
}

+ (SDLLockScreenStatus *)REQUIRED {
    if (SDLLockScreenStatus_REQUIRED == nil) {
        SDLLockScreenStatus_REQUIRED = [[SDLLockScreenStatus alloc] initWithValue:@"REQUIRED"];
    }
    return SDLLockScreenStatus_REQUIRED;
}


@end
