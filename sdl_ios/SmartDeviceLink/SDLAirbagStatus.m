//  SDLAirbagStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAirbagStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAirbagStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setDriverAirbagDeployed:(SDLVehicleDataEventStatus*) driverAirbagDeployed {
    [store setOrRemoveObject:driverAirbagDeployed forKey:NAMES_driverAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) driverAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_driverAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setDriverSideAirbagDeployed:(SDLVehicleDataEventStatus*) driverSideAirbagDeployed {
    [store setOrRemoveObject:driverSideAirbagDeployed forKey:NAMES_driverSideAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) driverSideAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_driverSideAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setDriverCurtainAirbagDeployed:(SDLVehicleDataEventStatus*) driverCurtainAirbagDeployed {
    [store setOrRemoveObject:driverCurtainAirbagDeployed forKey:NAMES_driverCurtainAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) driverCurtainAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_driverCurtainAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerAirbagDeployed:(SDLVehicleDataEventStatus*) passengerAirbagDeployed {
    [store setOrRemoveObject:passengerAirbagDeployed forKey:NAMES_passengerAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) passengerAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_passengerAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus*) passengerCurtainAirbagDeployed {
    [store setOrRemoveObject:passengerCurtainAirbagDeployed forKey:NAMES_passengerCurtainAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) passengerCurtainAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_passengerCurtainAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setDriverKneeAirbagDeployed:(SDLVehicleDataEventStatus*) driverKneeAirbagDeployed {
    [store setOrRemoveObject:driverKneeAirbagDeployed forKey:NAMES_driverKneeAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) driverKneeAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_driverKneeAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerSideAirbagDeployed:(SDLVehicleDataEventStatus*) passengerSideAirbagDeployed {
    [store setOrRemoveObject:passengerSideAirbagDeployed forKey:NAMES_passengerSideAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) passengerSideAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_passengerSideAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerKneeAirbagDeployed:(SDLVehicleDataEventStatus*) passengerKneeAirbagDeployed {
    [store setOrRemoveObject:passengerKneeAirbagDeployed forKey:NAMES_passengerKneeAirbagDeployed];
}

-(SDLVehicleDataEventStatus*) passengerKneeAirbagDeployed {
    NSObject* obj = [store objectForKey:NAMES_passengerKneeAirbagDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

@end
