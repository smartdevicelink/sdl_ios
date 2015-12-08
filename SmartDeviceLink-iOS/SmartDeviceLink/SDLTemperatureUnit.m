//
//  SDLTemperatureUnit.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLTemperatureUnit.h"

SDLTemperatureUnit *SDLTemperatureUnit_KELVIN = nil;
SDLTemperatureUnit *SDLTemperatureUnit_FAHRENHEIT = nil;
SDLTemperatureUnit *SDLTemperatureUnit_CELSIUS = nil;

NSArray *SDLTemperatureUnit_values = nil;

@implementation SDLTemperatureUnit

+ (SDLTemperatureUnit *)valueOf:(NSString *)value {
    for (SDLTemperatureUnit *item in SDLTemperatureUnit.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTemperatureUnit_values == nil) {
        SDLTemperatureUnit_values = @[[SDLTemperatureUnit KELVIN],
                                      [SDLTemperatureUnit FAHRENHEIT],
                                      [SDLTemperatureUnit CELSIUS]];
    }
    return SDLTemperatureUnit_values;
}

+ (SDLTemperatureUnit *)KELVIN {
    if (SDLTemperatureUnit_KELVIN == nil) {
        SDLTemperatureUnit_KELVIN = [[SDLTemperatureUnit alloc] initWithValue:@"KELVIN"];
    }
    
    return SDLTemperatureUnit_KELVIN;
}

+ (SDLTemperatureUnit *)FAHRENHEIT {
    if (SDLTemperatureUnit_FAHRENHEIT == nil) {
        SDLTemperatureUnit_FAHRENHEIT = [[SDLTemperatureUnit alloc] initWithValue:@"FAHRENHEIT"];
    }
    
    return SDLTemperatureUnit_FAHRENHEIT;
}

+ (SDLTemperatureUnit *)CELSIUS {
    if (SDLTemperatureUnit_CELSIUS == nil) {
        SDLTemperatureUnit_CELSIUS = [[SDLTemperatureUnit alloc] initWithValue:@"CELSIUS"];
    }
    
    return SDLTemperatureUnit_CELSIUS;
}

@end
