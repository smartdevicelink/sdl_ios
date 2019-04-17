//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAirbagStatus

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed {
    [store sdl_setObject:driverAirbagDeployed forName:SDLRPCParameterNameDriverAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameDriverAirbagDeployed error:&error];
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    [store sdl_setObject:driverSideAirbagDeployed forName:SDLRPCParameterNameDriverSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameDriverSideAirbagDeployed error:&error];
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    [store sdl_setObject:driverCurtainAirbagDeployed forName:SDLRPCParameterNameDriverCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameDriverCurtainAirbagDeployed error:&error];
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    [store sdl_setObject:passengerAirbagDeployed forName:SDLRPCParameterNamePassengerAirbagDeployed];}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNamePassengerAirbagDeployed error:&error];
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    [store sdl_setObject:passengerCurtainAirbagDeployed forName:SDLRPCParameterNamePassengerCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNamePassengerCurtainAirbagDeployed error:&error];
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    [store sdl_setObject:driverKneeAirbagDeployed forName:SDLRPCParameterNameDriverKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameDriverKneeAirbagDeployed error:&error];
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    [store sdl_setObject:passengerSideAirbagDeployed forName:SDLRPCParameterNamePassengerSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNamePassengerSideAirbagDeployed error:&error];
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    [store sdl_setObject:passengerKneeAirbagDeployed forName:SDLRPCParameterNamePassengerKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNamePassengerKneeAirbagDeployed error:&error];
}

@end

NS_ASSUME_NONNULL_END
