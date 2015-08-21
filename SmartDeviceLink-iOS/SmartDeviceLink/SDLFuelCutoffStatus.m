//  SDLFuelCutoffStatus.m
//


#import "SDLFuelCutoffStatus.h"

SDLFuelCutoffStatus *SDLFuelCutoffStatus_TERMINATE_FUEL = nil;
SDLFuelCutoffStatus *SDLFuelCutoffStatus_NORMAL_OPERATION = nil;
SDLFuelCutoffStatus *SDLFuelCutoffStatus_FAULT = nil;

NSArray *SDLFuelCutoffStatus_values = nil;

@implementation SDLFuelCutoffStatus

+ (SDLFuelCutoffStatus *)valueOf:(NSString *)value {
    for (SDLFuelCutoffStatus *item in SDLFuelCutoffStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLFuelCutoffStatus_values == nil) {
        SDLFuelCutoffStatus_values = @[
            SDLFuelCutoffStatus.TERMINATE_FUEL,
            SDLFuelCutoffStatus.NORMAL_OPERATION,
            SDLFuelCutoffStatus.FAULT,
        ];
    }
    return SDLFuelCutoffStatus_values;
}

+ (SDLFuelCutoffStatus *)TERMINATE_FUEL {
    if (SDLFuelCutoffStatus_TERMINATE_FUEL == nil) {
        SDLFuelCutoffStatus_TERMINATE_FUEL = [[SDLFuelCutoffStatus alloc] initWithValue:@"TERMINATE_FUEL"];
    }
    return SDLFuelCutoffStatus_TERMINATE_FUEL;
}

+ (SDLFuelCutoffStatus *)NORMAL_OPERATION {
    if (SDLFuelCutoffStatus_NORMAL_OPERATION == nil) {
        SDLFuelCutoffStatus_NORMAL_OPERATION = [[SDLFuelCutoffStatus alloc] initWithValue:@"NORMAL_OPERATION"];
    }
    return SDLFuelCutoffStatus_NORMAL_OPERATION;
}

+ (SDLFuelCutoffStatus *)FAULT {
    if (SDLFuelCutoffStatus_FAULT == nil) {
        SDLFuelCutoffStatus_FAULT = [[SDLFuelCutoffStatus alloc] initWithValue:@"FAULT"];
    }
    return SDLFuelCutoffStatus_FAULT;
}

@end
