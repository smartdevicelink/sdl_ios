//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "SDLNames.h"

@implementation SDLEmergencyEvent

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setEmergencyEventType:(SDLEmergencyEventType)emergencyEventType {
    if (emergencyEventType != nil) {
        [store setObject:emergencyEventType forKey:NAMES_emergencyEventType];
    } else {
        [store removeObjectForKey:NAMES_emergencyEventType];
    }
}

- (SDLEmergencyEventType)emergencyEventType {
    NSObject *obj = [store objectForKey:NAMES_emergencyEventType];
    return (SDLEmergencyEventType)obj;
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    if (fuelCutoffStatus != nil) {
        [store setObject:fuelCutoffStatus forKey:NAMES_fuelCutoffStatus];
    } else {
        [store removeObjectForKey:NAMES_fuelCutoffStatus];
    }
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    NSObject *obj = [store objectForKey:NAMES_fuelCutoffStatus];
    return (SDLFuelCutoffStatus)obj;
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    if (rolloverEvent != nil) {
        [store setObject:rolloverEvent forKey:NAMES_rolloverEvent];
    } else {
        [store removeObjectForKey:NAMES_rolloverEvent];
    }
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    NSObject *obj = [store objectForKey:NAMES_rolloverEvent];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setMaximumChangeVelocity:(NSNumber *)maximumChangeVelocity {
    if (maximumChangeVelocity != nil) {
        [store setObject:maximumChangeVelocity forKey:NAMES_maximumChangeVelocity];
    } else {
        [store removeObjectForKey:NAMES_maximumChangeVelocity];
    }
}

- (NSNumber *)maximumChangeVelocity {
    return [store objectForKey:NAMES_maximumChangeVelocity];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    if (multipleEvents != nil) {
        [store setObject:multipleEvents forKey:NAMES_multipleEvents];
    } else {
        [store removeObjectForKey:NAMES_multipleEvents];
    }
}

- (SDLVehicleDataEventStatus)multipleEvents {
    NSObject *obj = [store objectForKey:NAMES_multipleEvents];
    return (SDLVehicleDataEventStatus)obj;
}

@end
