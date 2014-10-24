//  SDLFuelCutoffStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLFuelCutoffStatus.h>

SDLFuelCutoffStatus* SDLFuelCutoffStatus_TERMINATE_FUEL = nil;
SDLFuelCutoffStatus* SDLFuelCutoffStatus_NORMAL_OPERATION = nil;
SDLFuelCutoffStatus* SDLFuelCutoffStatus_FAULT = nil;

NSMutableArray* SDLFuelCutoffStatus_values = nil;

@implementation SDLFuelCutoffStatus

+(SDLFuelCutoffStatus*) valueOf:(NSString*) value {
    for (SDLFuelCutoffStatus* item in SDLFuelCutoffStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLFuelCutoffStatus_values == nil) {
        SDLFuelCutoffStatus_values = [[NSMutableArray alloc] initWithObjects:
                SDLFuelCutoffStatus.TERMINATE_FUEL,
                SDLFuelCutoffStatus.NORMAL_OPERATION,
                SDLFuelCutoffStatus.FAULT,
                nil];
    }
    return SDLFuelCutoffStatus_values;
}

+(SDLFuelCutoffStatus*) TERMINATE_FUEL {
    if (SDLFuelCutoffStatus_TERMINATE_FUEL == nil) {
        SDLFuelCutoffStatus_TERMINATE_FUEL = [[SDLFuelCutoffStatus alloc] initWithValue:@"TERMINATE_FUEL"];
    }
    return SDLFuelCutoffStatus_TERMINATE_FUEL;
}

+(SDLFuelCutoffStatus*) NORMAL_OPERATION {
    if (SDLFuelCutoffStatus_NORMAL_OPERATION == nil) {
        SDLFuelCutoffStatus_NORMAL_OPERATION = [[SDLFuelCutoffStatus alloc] initWithValue:@"NORMAL_OPERATION"];
    }
    return SDLFuelCutoffStatus_NORMAL_OPERATION;
}

+(SDLFuelCutoffStatus*) FAULT {
    if (SDLFuelCutoffStatus_FAULT == nil) {
        SDLFuelCutoffStatus_FAULT = [[SDLFuelCutoffStatus alloc] initWithValue:@"FAULT"];
    }
    return SDLFuelCutoffStatus_FAULT;
}

@end
