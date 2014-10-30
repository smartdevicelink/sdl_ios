//  SDLEmergencyEvent.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLEmergencyEvent.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLEmergencyEvent

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setEmergencyEventType:(SDLEmergencyEventType*) emergencyEventType {
    [store setOrRemoveObject:emergencyEventType forKey:NAMES_emergencyEventType];
}

-(SDLEmergencyEventType*) emergencyEventType {
    NSObject* obj = [store objectForKey:NAMES_emergencyEventType];
    if ([obj isKindOfClass:SDLEmergencyEventType.class]) {
        return (SDLEmergencyEventType*)obj;
    } else {
        return [SDLEmergencyEventType valueOf:(NSString*)obj];
    }
}

-(void) setFuelCutoffStatus:(SDLFuelCutoffStatus*) fuelCutoffStatus {
    [store setOrRemoveObject:fuelCutoffStatus forKey:NAMES_fuelCutoffStatus];
}

-(SDLFuelCutoffStatus*) fuelCutoffStatus {
    NSObject* obj = [store objectForKey:NAMES_fuelCutoffStatus];
    if ([obj isKindOfClass:SDLFuelCutoffStatus.class]) {
        return (SDLFuelCutoffStatus*)obj;
    } else {
        return [SDLFuelCutoffStatus valueOf:(NSString*)obj];
    }
}

-(void) setRolloverEvent:(SDLVehicleDataEventStatus*) rolloverEvent {
    [store setOrRemoveObject:rolloverEvent forKey:NAMES_rolloverEvent];
}

-(SDLVehicleDataEventStatus*) rolloverEvent {
    NSObject* obj = [store objectForKey:NAMES_rolloverEvent];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setMaximumChangeVelocity:(NSNumber*) maximumChangeVelocity {
    [store setOrRemoveObject:maximumChangeVelocity forKey:NAMES_maximumChangeVelocity];
}

-(NSNumber*) maximumChangeVelocity {
    return [store objectForKey:NAMES_maximumChangeVelocity];
}

-(void) setMultipleEvents:(SDLVehicleDataEventStatus*) multipleEvents {
    [store setOrRemoveObject:multipleEvents forKey:NAMES_multipleEvents];
}

-(SDLVehicleDataEventStatus*) multipleEvents {
    NSObject* obj = [store objectForKey:NAMES_multipleEvents];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

@end
