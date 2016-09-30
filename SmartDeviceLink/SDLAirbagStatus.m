//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"

@implementation SDLAirbagStatus

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus *)driverAirbagDeployed {
    if (driverAirbagDeployed != nil) {
        [store setObject:driverAirbagDeployed forKey:SDLNameDriverAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus *)driverSideAirbagDeployed {
    if (driverSideAirbagDeployed != nil) {
        [store setObject:driverSideAirbagDeployed forKey:SDLNameDriverSideAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverSideAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverSideAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus *)driverCurtainAirbagDeployed {
    if (driverCurtainAirbagDeployed != nil) {
        [store setObject:driverCurtainAirbagDeployed forKey:SDLNameDriverCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverCurtainAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus *)passengerAirbagDeployed {
    if (passengerAirbagDeployed != nil) {
        [store setObject:passengerAirbagDeployed forKey:SDLNamePassengerAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus *)passengerCurtainAirbagDeployed {
    if (passengerCurtainAirbagDeployed != nil) {
        [store setObject:passengerCurtainAirbagDeployed forKey:SDLNamePassengerCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerCurtainAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus *)driverKneeAirbagDeployed {
    if (driverKneeAirbagDeployed != nil) {
        [store setObject:driverKneeAirbagDeployed forKey:SDLNameDriverKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverKneeAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus *)passengerSideAirbagDeployed {
    if (passengerSideAirbagDeployed != nil) {
        [store setObject:passengerSideAirbagDeployed forKey:SDLNamePassengerSideAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerSideAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerSideAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus *)passengerKneeAirbagDeployed {
    if (passengerKneeAirbagDeployed != nil) {
        [store setObject:passengerKneeAirbagDeployed forKey:SDLNamePassengerKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerKneeAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

@end
