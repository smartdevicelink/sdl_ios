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
    return [store sdl_objectForName:SDLRPCParameterNameDriverAirbagDeployed];
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    [store sdl_setObject:driverSideAirbagDeployed forName:SDLRPCParameterNameDriverSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNameDriverSideAirbagDeployed];
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    [store sdl_setObject:driverCurtainAirbagDeployed forName:SDLRPCParameterNameDriverCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNameDriverCurtainAirbagDeployed];
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    [store sdl_setObject:passengerAirbagDeployed forName:SDLRPCParameterNamePassengerAirbagDeployed];}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerAirbagDeployed];
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    [store sdl_setObject:passengerCurtainAirbagDeployed forName:SDLRPCParameterNamePassengerCurtainAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerCurtainAirbagDeployed];
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    [store sdl_setObject:driverKneeAirbagDeployed forName:SDLRPCParameterNameDriverKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNameDriverKneeAirbagDeployed];
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    [store sdl_setObject:passengerSideAirbagDeployed forName:SDLRPCParameterNamePassengerSideAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerSideAirbagDeployed];
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    [store sdl_setObject:passengerKneeAirbagDeployed forName:SDLRPCParameterNamePassengerKneeAirbagDeployed];
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerKneeAirbagDeployed];
}

@end

NS_ASSUME_NONNULL_END
