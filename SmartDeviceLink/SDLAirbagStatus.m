//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAirbagStatus

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed {
    if (driverAirbagDeployed != nil) {
        [store setObject:driverAirbagDeployed forKey:SDLNameDriverAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    if (driverSideAirbagDeployed != nil) {
        [store setObject:driverSideAirbagDeployed forKey:SDLNameDriverSideAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverSideAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    if (driverCurtainAirbagDeployed != nil) {
        [store setObject:driverCurtainAirbagDeployed forKey:SDLNameDriverCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverCurtainAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    if (passengerAirbagDeployed != nil) {
        [store setObject:passengerAirbagDeployed forKey:SDLNamePassengerAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    if (passengerCurtainAirbagDeployed != nil) {
        [store setObject:passengerCurtainAirbagDeployed forKey:SDLNamePassengerCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerCurtainAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    if (driverKneeAirbagDeployed != nil) {
        [store setObject:driverKneeAirbagDeployed forKey:SDLNameDriverKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverKneeAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    if (passengerSideAirbagDeployed != nil) {
        [store setObject:passengerSideAirbagDeployed forKey:SDLNamePassengerSideAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerSideAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    if (passengerKneeAirbagDeployed != nil) {
        [store setObject:passengerKneeAirbagDeployed forKey:SDLNamePassengerKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerKneeAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

@end

NS_ASSUME_NONNULL_END
