//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEmergencyEvent

- (void)setEmergencyEventType:(SDLEmergencyEventType)emergencyEventType {
    [store sdl_setObject:emergencyEventType forName:SDLRPCParameterNameEmergencyEventType];
}

- (SDLEmergencyEventType)emergencyEventType {
    return [store sdl_objectForName:SDLRPCParameterNameEmergencyEventType];
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    [store sdl_setObject:fuelCutoffStatus forName:SDLRPCParameterNameFuelCutoffStatus];
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    return [store sdl_objectForName:SDLRPCParameterNameFuelCutoffStatus];
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    [store sdl_setObject:rolloverEvent forName:SDLRPCParameterNameRolloverEvent];
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    return [store sdl_objectForName:SDLRPCParameterNameRolloverEvent];
}

- (void)setMaximumChangeVelocity:(NSNumber<SDLInt> *)maximumChangeVelocity {
    [store sdl_setObject:maximumChangeVelocity forName:SDLRPCParameterNameMaximumChangeVelocity];
}

- (NSNumber<SDLInt> *)maximumChangeVelocity {
    return [store sdl_objectForName:SDLRPCParameterNameMaximumChangeVelocity];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    [store sdl_setObject:multipleEvents forName:SDLRPCParameterNameMultipleEvents];
}

- (SDLVehicleDataEventStatus)multipleEvents {
    return [store sdl_objectForName:SDLRPCParameterNameMultipleEvents];
}

@end

NS_ASSUME_NONNULL_END
