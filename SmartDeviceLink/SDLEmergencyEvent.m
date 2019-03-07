//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEmergencyEvent

- (void)setEmergencyEventType:(SDLEmergencyEventType)emergencyEventType {
    [store sdl_setObject:emergencyEventType forName:SDLNameEmergencyEventType];
}

- (SDLEmergencyEventType)emergencyEventType {
    NSError *error;
    return [store sdl_enumForName:SDLNameEmergencyEventType error:&error];
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    [store sdl_setObject:fuelCutoffStatus forName:SDLNameFuelCutoffStatus];
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameFuelCutoffStatus error:&error];
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    [store sdl_setObject:rolloverEvent forName:SDLNameRolloverEvent];
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    NSError *error;
    return [store sdl_enumForName:SDLNameRolloverEvent error:&error];
}

- (void)setMaximumChangeVelocity:(NSNumber<SDLInt> *)maximumChangeVelocity {
    [store sdl_setObject:maximumChangeVelocity forName:SDLNameMaximumChangeVelocity];
}

- (NSNumber<SDLInt> *)maximumChangeVelocity {
    NSError *error;
    return [store sdl_objectForName:SDLNameMaximumChangeVelocity ofClass:NSNumber.class error:&error];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    [store sdl_setObject:multipleEvents forName:SDLNameMultipleEvents];
}

- (SDLVehicleDataEventStatus)multipleEvents {
    NSError *error;
    return [store sdl_enumForName:SDLNameMultipleEvents error:&error];
}

@end

NS_ASSUME_NONNULL_END
