//  SDLVehicleDataEventStatus.m
//


#import "SDLVehicleDataEventStatus.h"

SDLVehicleDataEventStatus *SDLVehicleDataEventStatus_NO_EVENT = nil;
SDLVehicleDataEventStatus *SDLVehicleDataEventStatus_NO = nil;
SDLVehicleDataEventStatus *SDLVehicleDataEventStatus_YES = nil;
SDLVehicleDataEventStatus *SDLVehicleDataEventStatus_NOT_SUPPORTED = nil;
SDLVehicleDataEventStatus *SDLVehicleDataEventStatus_FAULT = nil;

NSArray *SDLVehicleDataEventStatus_values = nil;

@implementation SDLVehicleDataEventStatus

+ (SDLVehicleDataEventStatus *)valueOf:(NSString *)value {
    for (SDLVehicleDataEventStatus *item in SDLVehicleDataEventStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVehicleDataEventStatus_values == nil) {
        SDLVehicleDataEventStatus_values = @[
            SDLVehicleDataEventStatus.NO_EVENT,
            SDLVehicleDataEventStatus._NO,
            SDLVehicleDataEventStatus._YES,
            SDLVehicleDataEventStatus.NOT_SUPPORTED,
            SDLVehicleDataEventStatus.FAULT,
        ];
    }
    return SDLVehicleDataEventStatus_values;
}

+ (SDLVehicleDataEventStatus *)NO_EVENT {
    if (SDLVehicleDataEventStatus_NO_EVENT == nil) {
        SDLVehicleDataEventStatus_NO_EVENT = [[SDLVehicleDataEventStatus alloc] initWithValue:@"NO_EVENT"];
    }
    return SDLVehicleDataEventStatus_NO_EVENT;
}

+ (SDLVehicleDataEventStatus *)_NO {
    if (SDLVehicleDataEventStatus_NO == nil) {
        SDLVehicleDataEventStatus_NO = [[SDLVehicleDataEventStatus alloc] initWithValue:@"NO"];
    }
    return SDLVehicleDataEventStatus_NO;
}

+ (SDLVehicleDataEventStatus *)_YES {
    if (SDLVehicleDataEventStatus_YES == nil) {
        SDLVehicleDataEventStatus_YES = [[SDLVehicleDataEventStatus alloc] initWithValue:@"YES"];
    }
    return SDLVehicleDataEventStatus_YES;
}

+ (SDLVehicleDataEventStatus *)NOT_SUPPORTED {
    if (SDLVehicleDataEventStatus_NOT_SUPPORTED == nil) {
        SDLVehicleDataEventStatus_NOT_SUPPORTED = [[SDLVehicleDataEventStatus alloc] initWithValue:@"NOT_SUPPORTED"];
    }
    return SDLVehicleDataEventStatus_NOT_SUPPORTED;
}

+ (SDLVehicleDataEventStatus *)FAULT {
    if (SDLVehicleDataEventStatus_FAULT == nil) {
        SDLVehicleDataEventStatus_FAULT = [[SDLVehicleDataEventStatus alloc] initWithValue:@"FAULT"];
    }
    return SDLVehicleDataEventStatus_FAULT;
}

@end
