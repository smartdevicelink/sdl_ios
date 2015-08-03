//  SDLVehicleDataActiveStatus.m
//


#import "SDLVehicleDataActiveStatus.h"

SDLVehicleDataActiveStatus *SDLVehicleDataActiveStatus_INACTIVE_NOT_CONFIRMED = nil;
SDLVehicleDataActiveStatus *SDLVehicleDataActiveStatus_INACTIVE_CONFIRMED = nil;
SDLVehicleDataActiveStatus *SDLVehicleDataActiveStatus_ACTIVE_NOT_CONFIRMED = nil;
SDLVehicleDataActiveStatus *SDLVehicleDataActiveStatus_ACTIVE_CONFIRMED = nil;
SDLVehicleDataActiveStatus *SDLVehicleDataActiveStatus_FAULT = nil;

NSArray *SDLVehicleDataActiveStatus_values = nil;

@implementation SDLVehicleDataActiveStatus

+ (SDLVehicleDataActiveStatus *)valueOf:(NSString *)value {
    for (SDLVehicleDataActiveStatus *item in SDLVehicleDataActiveStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVehicleDataActiveStatus_values == nil) {
        SDLVehicleDataActiveStatus_values = @[
            SDLVehicleDataActiveStatus.INACTIVE_NOT_CONFIRMED,
            SDLVehicleDataActiveStatus.INACTIVE_CONFIRMED,
            SDLVehicleDataActiveStatus.ACTIVE_NOT_CONFIRMED,
            SDLVehicleDataActiveStatus.ACTIVE_CONFIRMED,
            SDLVehicleDataActiveStatus.FAULT,
        ];
    }
    return SDLVehicleDataActiveStatus_values;
}

+ (SDLVehicleDataActiveStatus *)INACTIVE_NOT_CONFIRMED {
    if (SDLVehicleDataActiveStatus_INACTIVE_NOT_CONFIRMED == nil) {
        SDLVehicleDataActiveStatus_INACTIVE_NOT_CONFIRMED = [[SDLVehicleDataActiveStatus alloc] initWithValue:@"INACTIVE_NOT_CONFIRMED"];
    }
    return SDLVehicleDataActiveStatus_INACTIVE_NOT_CONFIRMED;
}

+ (SDLVehicleDataActiveStatus *)INACTIVE_CONFIRMED {
    if (SDLVehicleDataActiveStatus_INACTIVE_CONFIRMED == nil) {
        SDLVehicleDataActiveStatus_INACTIVE_CONFIRMED = [[SDLVehicleDataActiveStatus alloc] initWithValue:@"INACTIVE_CONFIRMED"];
    }
    return SDLVehicleDataActiveStatus_INACTIVE_CONFIRMED;
}

+ (SDLVehicleDataActiveStatus *)ACTIVE_NOT_CONFIRMED {
    if (SDLVehicleDataActiveStatus_ACTIVE_NOT_CONFIRMED == nil) {
        SDLVehicleDataActiveStatus_ACTIVE_NOT_CONFIRMED = [[SDLVehicleDataActiveStatus alloc] initWithValue:@"ACTIVE_NOT_CONFIRMED"];
    }
    return SDLVehicleDataActiveStatus_ACTIVE_NOT_CONFIRMED;
}

+ (SDLVehicleDataActiveStatus *)ACTIVE_CONFIRMED {
    if (SDLVehicleDataActiveStatus_ACTIVE_CONFIRMED == nil) {
        SDLVehicleDataActiveStatus_ACTIVE_CONFIRMED = [[SDLVehicleDataActiveStatus alloc] initWithValue:@"ACTIVE_CONFIRMED"];
    }
    return SDLVehicleDataActiveStatus_ACTIVE_CONFIRMED;
}

+ (SDLVehicleDataActiveStatus *)FAULT {
    if (SDLVehicleDataActiveStatus_FAULT == nil) {
        SDLVehicleDataActiveStatus_FAULT = [[SDLVehicleDataActiveStatus alloc] initWithValue:@"FAULT"];
    }
    return SDLVehicleDataActiveStatus_FAULT;
}

@end
