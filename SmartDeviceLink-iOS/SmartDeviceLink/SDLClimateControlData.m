//
//  SDLClimateControlData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLClimateControlData.h"

#import "SDLDefrostZone.h"
#import "SDLNames.h"
#import "SDLTemperatureUnit.h"


@implementation SDLClimateControlData

- (void)setFanSpeed:(NSNumber *)fanSpeed {
    if (fanSpeed != nil) {
        [store setObject:fanSpeed forKey:NAMES_fanSpeed];
    } else {
        [store removeObjectForKey:NAMES_fanSpeed];
    }
}

- (NSNumber *)fanSpeed {
    return [store objectForKey:NAMES_fanSpeed];
}

- (void)setCurrentTemperature:(NSNumber *)currentTemperature {
    if (currentTemperature != nil) {
        [store setObject:currentTemperature forKey:NAMES_currentTemp];
    } else {
        [store removeObjectForKey:NAMES_currentTemp];
    }
}

- (NSNumber *)currentTemperature {
    return [store objectForKey:NAMES_currentTemp];
}

- (void)setDesiredTemperature:(NSNumber *)desiredTemperature {
    if (desiredTemperature != nil) {
        [store setObject:desiredTemperature forKey:NAMES_desiredTemp];
    } else {
        [store removeObjectForKey:NAMES_desiredTemp];
    }
}

- (NSNumber *)desiredTemperature {
    return [store objectForKey:NAMES_desiredTemp];
}

- (void)setTemperatureUnit:(SDLTemperatureUnit *)temperatureUnit {
    if (temperatureUnit != nil) {
        [store setObject:temperatureUnit forKey:NAMES_temperatureUnit];
    } else {
        [store removeObjectForKey:NAMES_temperatureUnit];
    }
}

- (SDLTemperatureUnit *)temperatureUnit {
    NSObject *obj = [store objectForKey:NAMES_temperatureUnit];
    if ([obj isKindOfClass:[SDLTemperatureUnit class]]) {
        return (SDLTemperatureUnit *)obj;
    } else {
        return [SDLTemperatureUnit valueOf:(NSString *)obj];
    }
}

- (void)setAirConditioningOn:(NSNumber *)airConditioningOn {
    if (airConditioningOn != nil) {
        [store setObject:airConditioningOn forKey:NAMES_acEnable];
    } else {
        [store removeObjectForKey:NAMES_acEnable];
    }
}

- (NSNumber *)airConditioningOn {
    return [store objectForKey:NAMES_acEnable];
}

- (void)setAutoModeOn:(NSNumber *)autoModeOn {
    if (autoModeOn != nil) {
        [store setObject:autoModeOn forKey:NAMES_autoModeEnable];
    } else {
        [store removeObjectForKey:NAMES_autoModeEnable];
    }
}

- (NSNumber *)autoModeOn {
    return [store objectForKey:NAMES_autoModeEnable];
}

- (void)setDefrostZone:(SDLDefrostZone *)defrostZone {
    if (defrostZone != nil) {
        [store setObject:defrostZone forKey:NAMES_defrostZone];
    } else {
        [store removeObjectForKey:NAMES_defrostZone];
    }
}

- (SDLDefrostZone *)defrostZone {
    NSObject *obj = [store objectForKey:NAMES_moduleType];
    if ([obj isKindOfClass:[SDLDefrostZone class]]) {
        return (SDLDefrostZone *)obj;
    } else {
        return [SDLDefrostZone valueOf:(NSString *)obj];
    }
}

- (void)setDualModeOn:(NSNumber *)dualModeOn {
    if (dualModeOn != nil) {
        [store setObject:dualModeOn forKey:NAMES_dualModeEnable];
    } else {
        [store removeObjectForKey:NAMES_dualModeEnable];
    }
}

- (NSNumber *)dualModeOn {
    return [store objectForKey:NAMES_dualModeEnable];
}

@end
