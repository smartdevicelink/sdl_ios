//  SDLAirbagStatus.m

#import "SDLAirbagStatus.h"

#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"


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

- (void)setDriverAirbagDeployed:(SDLVehicleDataEventStatus *)driverAirbagDeployed {
    if (driverAirbagDeployed != nil) {
        [store setObject:driverAirbagDeployed forKey:NAMES_driverAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus *)driverSideAirbagDeployed {
    if (driverSideAirbagDeployed != nil) {
        [store setObject:driverSideAirbagDeployed forKey:NAMES_driverSideAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverSideAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverSideAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus *)driverCurtainAirbagDeployed {
    if (driverCurtainAirbagDeployed != nil) {
        [store setObject:driverCurtainAirbagDeployed forKey:NAMES_driverCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverCurtainAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerAirbagDeployed:(SDLVehicleDataEventStatus *)passengerAirbagDeployed {
    if (passengerAirbagDeployed != nil) {
        [store setObject:passengerAirbagDeployed forKey:NAMES_passengerAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus *)passengerCurtainAirbagDeployed {
    if (passengerCurtainAirbagDeployed != nil) {
        [store setObject:passengerCurtainAirbagDeployed forKey:NAMES_passengerCurtainAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerCurtainAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerCurtainAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerCurtainAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus *)driverKneeAirbagDeployed {
    if (driverKneeAirbagDeployed != nil) {
        [store setObject:driverKneeAirbagDeployed forKey:NAMES_driverKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverKneeAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus *)passengerSideAirbagDeployed {
    if (passengerSideAirbagDeployed != nil) {
        [store setObject:passengerSideAirbagDeployed forKey:NAMES_passengerSideAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerSideAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerSideAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerSideAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus *)passengerKneeAirbagDeployed {
    if (passengerKneeAirbagDeployed != nil) {
        [store setObject:passengerKneeAirbagDeployed forKey:NAMES_passengerKneeAirbagDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerKneeAirbagDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerKneeAirbagDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerKneeAirbagDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

@end
