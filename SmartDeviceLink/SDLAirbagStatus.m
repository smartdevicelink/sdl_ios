//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "SDLNames.h"

@implementation SDLAirbagStatus

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed {
    if (driverAirbagDeployed != nil) {
        [store setObject:driverAirbagDeployed forKey:NAMES_driverAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    if (driverSideAirbagDeployed != nil) {
        [store setObject:driverSideAirbagDeployed forKey:NAMES_driverSideAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverSideAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverSideAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    if (driverCurtainAirbagDeployed != nil) {
        [store setObject:driverCurtainAirbagDeployed forKey:NAMES_driverCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverCurtainAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed {
    if (passengerAirbagDeployed != nil) {
        [store setObject:passengerAirbagDeployed forKey:NAMES_passengerAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    if (passengerCurtainAirbagDeployed != nil) {
        [store setObject:passengerCurtainAirbagDeployed forKey:NAMES_passengerCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerCurtainAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    if (driverKneeAirbagDeployed != nil) {
        [store setObject:driverKneeAirbagDeployed forKey:NAMES_driverKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverKneeAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    if (passengerSideAirbagDeployed != nil) {
        [store setObject:passengerSideAirbagDeployed forKey:NAMES_passengerSideAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerSideAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerSideAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    if (passengerKneeAirbagDeployed != nil) {
        [store setObject:passengerKneeAirbagDeployed forKey:NAMES_passengerKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerKneeAirbagDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

@end
