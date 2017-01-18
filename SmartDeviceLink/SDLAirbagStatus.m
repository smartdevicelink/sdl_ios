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
    return [store sdl_objectForName:SDLNameDriverAirbagDeployed];
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    [store sdl_setObject:driverSideAirbagDeployed forName:SDLNameDriverSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    return [store sdl_objectForName:SDLNameDriverSideAirbagDeployed];
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    [store sdl_setObject:driverCurtainAirbagDeployed forName:SDLNameDriverCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    return [store sdl_objectForName:SDLNameDriverCurtainAirbagDeployed];
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    [store sdl_setObject:passengerAirbagDeployed forName:SDLNamePassengerAirbagDeployed];}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    return [store sdl_objectForName:SDLNamePassengerAirbagDeployed];
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    [store sdl_setObject:passengerCurtainAirbagDeployed forName:SDLNamePassengerCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    return [store sdl_objectForName:SDLNamePassengerCurtainAirbagDeployed];
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    [store sdl_setObject:driverKneeAirbagDeployed forName:SDLNameDriverKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    return [store sdl_objectForName:SDLNameDriverKneeAirbagDeployed];
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    [store sdl_setObject:passengerSideAirbagDeployed forName:SDLNamePassengerSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    return [store sdl_objectForName:SDLNamePassengerSideAirbagDeployed];
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    [store sdl_setObject:passengerKneeAirbagDeployed forName:SDLNamePassengerKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    return [store sdl_objectForName:SDLNamePassengerKneeAirbagDeployed];
}

@end

NS_ASSUME_NONNULL_END
