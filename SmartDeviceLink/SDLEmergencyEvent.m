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
    return [store sdl_objectForName:SDLNameEmergencyEventType];
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    [store sdl_setObject:fuelCutoffStatus forName:SDLNameFuelCutoffStatus];
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    return [store sdl_objectForName:SDLNameFuelCutoffStatus];
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    [store sdl_setObject:rolloverEvent forName:SDLNameRolloverEvent];
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    return [store sdl_objectForName:SDLNameRolloverEvent];
}

- (void)setMaximumChangeVelocity:(NSNumber<SDLInt> *)maximumChangeVelocity {
    [store sdl_setObject:maximumChangeVelocity forName:SDLNameMaximumChangeVelocity];
}

- (NSNumber<SDLInt> *)maximumChangeVelocity {
    return [store sdl_objectForName:SDLNameMaximumChangeVelocity];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    [store sdl_setObject:multipleEvents forName:SDLNameMultipleEvents];
}

- (SDLVehicleDataEventStatus)multipleEvents {
    return [store sdl_objectForName:SDLNameMultipleEvents];
}

@end

NS_ASSUME_NONNULL_END
