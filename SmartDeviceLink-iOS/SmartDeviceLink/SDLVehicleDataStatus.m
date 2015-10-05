//  SDLVehicleDataStatus.m
//


#import "SDLVehicleDataStatus.h"

SDLVehicleDataStatus *SDLVehicleDataStatus_NO_DATA_EXISTS = nil;
SDLVehicleDataStatus *SDLVehicleDataStatus_OFF = nil;
SDLVehicleDataStatus *SDLVehicleDataStatus_ON = nil;

NSArray *SDLVehicleDataStatus_values = nil;

@implementation SDLVehicleDataStatus

+ (SDLVehicleDataStatus *)valueOf:(NSString *)value {
    for (SDLVehicleDataStatus *item in SDLVehicleDataStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVehicleDataStatus_values == nil) {
        SDLVehicleDataStatus_values = @[
            SDLVehicleDataStatus.NO_DATA_EXISTS,
            SDLVehicleDataStatus.OFF,
            SDLVehicleDataStatus.ON,
        ];
    }
    return SDLVehicleDataStatus_values;
}

+ (SDLVehicleDataStatus *)NO_DATA_EXISTS {
    if (SDLVehicleDataStatus_NO_DATA_EXISTS == nil) {
        SDLVehicleDataStatus_NO_DATA_EXISTS = [[SDLVehicleDataStatus alloc] initWithValue:@"NO_DATA_EXISTS"];
    }
    return SDLVehicleDataStatus_NO_DATA_EXISTS;
}

+ (SDLVehicleDataStatus *)OFF {
    if (SDLVehicleDataStatus_OFF == nil) {
        SDLVehicleDataStatus_OFF = [[SDLVehicleDataStatus alloc] initWithValue:@"OFF"];
    }
    return SDLVehicleDataStatus_OFF;
}

+ (SDLVehicleDataStatus *)ON {
    if (SDLVehicleDataStatus_ON == nil) {
        SDLVehicleDataStatus_ON = [[SDLVehicleDataStatus alloc] initWithValue:@"ON"];
    }
    return SDLVehicleDataStatus_ON;
}

@end
