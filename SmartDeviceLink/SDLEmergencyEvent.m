//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"

@implementation SDLEmergencyEvent

- (void)setEmergencyEventType:(SDLEmergencyEventType *)emergencyEventType {
    if (emergencyEventType != nil) {
        [store setObject:emergencyEventType forKey:SDLNameEmergencyEventType];
    } else {
        [store removeObjectForKey:SDLNameEmergencyEventType];
    }
}

- (SDLEmergencyEventType *)emergencyEventType {
    NSObject *obj = [store objectForKey:SDLNameEmergencyEventType];
    if (obj == nil || [obj isKindOfClass:SDLEmergencyEventType.class]) {
        return (SDLEmergencyEventType *)obj;
    } else {
        return [SDLEmergencyEventType valueOf:(NSString *)obj];
    }
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus *)fuelCutoffStatus {
    if (fuelCutoffStatus != nil) {
        [store setObject:fuelCutoffStatus forKey:SDLNameFuelCutoffStatus];
    } else {
        [store removeObjectForKey:SDLNameFuelCutoffStatus];
    }
}

- (SDLFuelCutoffStatus *)fuelCutoffStatus {
    NSObject *obj = [store objectForKey:SDLNameFuelCutoffStatus];
    if (obj == nil || [obj isKindOfClass:SDLFuelCutoffStatus.class]) {
        return (SDLFuelCutoffStatus *)obj;
    } else {
        return [SDLFuelCutoffStatus valueOf:(NSString *)obj];
    }
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus *)rolloverEvent {
    if (rolloverEvent != nil) {
        [store setObject:rolloverEvent forKey:SDLNameRolloverEvent];
    } else {
        [store removeObjectForKey:SDLNameRolloverEvent];
    }
}

- (SDLVehicleDataEventStatus *)rolloverEvent {
    NSObject *obj = [store objectForKey:SDLNameRolloverEvent];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMaximumChangeVelocity:(NSNumber *)maximumChangeVelocity {
    if (maximumChangeVelocity != nil) {
        [store setObject:maximumChangeVelocity forKey:SDLNameMaximumChangeVelocity];
    } else {
        [store removeObjectForKey:SDLNameMaximumChangeVelocity];
    }
}

- (NSNumber *)maximumChangeVelocity {
    return [store objectForKey:SDLNameMaximumChangeVelocity];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus *)multipleEvents {
    if (multipleEvents != nil) {
        [store setObject:multipleEvents forKey:SDLNameMultipleEvents];
    } else {
        [store removeObjectForKey:SDLNameMultipleEvents];
    }
}

- (SDLVehicleDataEventStatus *)multipleEvents {
    NSObject *obj = [store objectForKey:SDLNameMultipleEvents];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

@end
