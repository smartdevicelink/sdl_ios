//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "SDLNames.h"

@implementation SDLEmergencyEvent

- (void)setEmergencyEventType:(SDLEmergencyEventType)emergencyEventType {
    [self setObject:emergencyEventType forName:SDLNameEmergencyEventType];
}

- (SDLEmergencyEventType)emergencyEventType {
    return [self objectForName:SDLNameEmergencyEventType];
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    [self setObject:fuelCutoffStatus forName:SDLNameFuelCutoffStatus];
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    return [self objectForName:SDLNameFuelCutoffStatus];
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    [self setObject:rolloverEvent forName:SDLNameRolloverEvent];
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    return [self objectForName:SDLNameRolloverEvent];
}

- (void)setMaximumChangeVelocity:(NSNumber<SDLInt> *)maximumChangeVelocity {
    [self setObject:maximumChangeVelocity forName:SDLNameMaximumChangeVelocity];
}

- (NSNumber<SDLInt> *)maximumChangeVelocity {
    return [self objectForName:SDLNameMaximumChangeVelocity];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    [self setObject:multipleEvents forName:SDLNameMultipleEvents];
}

- (SDLVehicleDataEventStatus)multipleEvents {
    return [self objectForName:SDLNameMultipleEvents];
}

@end
