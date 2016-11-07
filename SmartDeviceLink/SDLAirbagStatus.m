//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "SDLNames.h"

@implementation SDLAirbagStatus

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed {
    [self setObject:driverAirbagDeployed forName:SDLNameDriverAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverAirbagDeployed {
    return [self objectForName:SDLNameDriverAirbagDeployed];
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    [self setObject:driverSideAirbagDeployed forName:SDLNameDriverSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    return [self objectForName:SDLNameDriverSideAirbagDeployed];
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    [self setObject:driverCurtainAirbagDeployed forName:SDLNameDriverCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    return [self objectForName:SDLNameDriverCurtainAirbagDeployed];
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    [self setObject:passengerAirbagDeployed forName:SDLNamePassengerAirbagDeployed];}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    return [self objectForName:SDLNamePassengerAirbagDeployed];
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    [self setObject:passengerCurtainAirbagDeployed forName:SDLNamePassengerCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    return [self objectForName:SDLNamePassengerCurtainAirbagDeployed];
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    [self setObject:driverKneeAirbagDeployed forName:SDLNameDriverKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    return [self objectForName:SDLNameDriverKneeAirbagDeployed];
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    [self setObject:passengerSideAirbagDeployed forName:SDLNamePassengerSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    return [self objectForName:SDLNamePassengerSideAirbagDeployed];
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    [self setObject:passengerKneeAirbagDeployed forName:SDLNamePassengerKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    return [self objectForName:SDLNamePassengerKneeAirbagDeployed];
}

@end
