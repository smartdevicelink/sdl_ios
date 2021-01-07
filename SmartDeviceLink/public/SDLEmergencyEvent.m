//  SDLEmergencyEvent.m
//

#import "SDLEmergencyEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEmergencyEvent

- (instancetype)initWithEmergencyEventType:(SDLEmergencyEventType)emergencyEventType fuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus rolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent maximumChangeVelocity:(UInt8)maximumChangeVelocity multipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.emergencyEventType = emergencyEventType;
    self.fuelCutoffStatus = fuelCutoffStatus;
    self.rolloverEvent = rolloverEvent;
    self.maximumChangeVelocity = @(maximumChangeVelocity);
    self.multipleEvents = multipleEvents;
    return self;
}

- (void)setEmergencyEventType:(SDLEmergencyEventType)emergencyEventType {
    [self.store sdl_setObject:emergencyEventType forName:SDLRPCParameterNameEmergencyEventType];
}

- (SDLEmergencyEventType)emergencyEventType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameEmergencyEventType error:&error];
}

- (void)setFuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus {
    [self.store sdl_setObject:fuelCutoffStatus forName:SDLRPCParameterNameFuelCutoffStatus];
}

- (SDLFuelCutoffStatus)fuelCutoffStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameFuelCutoffStatus error:&error];
}

- (void)setRolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent {
    [self.store sdl_setObject:rolloverEvent forName:SDLRPCParameterNameRolloverEvent];
}

- (SDLVehicleDataEventStatus)rolloverEvent {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameRolloverEvent error:&error];
}

- (void)setMaximumChangeVelocity:(NSNumber<SDLInt> *)maximumChangeVelocity {
    [self.store sdl_setObject:maximumChangeVelocity forName:SDLRPCParameterNameMaximumChangeVelocity];
}

- (NSNumber<SDLInt> *)maximumChangeVelocity {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMaximumChangeVelocity ofClass:NSNumber.class error:&error];
}

- (void)setMultipleEvents:(SDLVehicleDataEventStatus)multipleEvents {
    [self.store sdl_setObject:multipleEvents forName:SDLRPCParameterNameMultipleEvents];
}

- (SDLVehicleDataEventStatus)multipleEvents {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMultipleEvents error:&error];
}

@end

NS_ASSUME_NONNULL_END
