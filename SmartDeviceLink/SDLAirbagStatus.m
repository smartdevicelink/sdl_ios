//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAirbagStatus

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed {
    [store sdl_setObject:driverAirbagDeployed forName:SDLNameDriverAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverAirbagDeployed error:&error];
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    [store sdl_setObject:driverSideAirbagDeployed forName:SDLNameDriverSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverSideAirbagDeployed error:&error];
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    [store sdl_setObject:driverCurtainAirbagDeployed forName:SDLNameDriverCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverCurtainAirbagDeployed error:&error];
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    [store sdl_setObject:passengerAirbagDeployed forName:SDLNamePassengerAirbagDeployed];}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerAirbagDeployed error:&error];
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    [store sdl_setObject:passengerCurtainAirbagDeployed forName:SDLNamePassengerCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerCurtainAirbagDeployed error:&error];
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    [store sdl_setObject:driverKneeAirbagDeployed forName:SDLNameDriverKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverKneeAirbagDeployed error:&error];
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    [store sdl_setObject:passengerSideAirbagDeployed forName:SDLNamePassengerSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerSideAirbagDeployed error:&error];
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    [store sdl_setObject:passengerKneeAirbagDeployed forName:SDLNamePassengerKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerKneeAirbagDeployed error:&error];
}

@end

NS_ASSUME_NONNULL_END
