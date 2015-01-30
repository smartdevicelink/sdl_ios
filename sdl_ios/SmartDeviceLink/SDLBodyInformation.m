//  SDLBodyInformation.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLBodyInformation.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLBodyInformation

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setParkBrakeActive:(NSNumber*) parkBrakeActive {
    [store setOrRemoveObject:parkBrakeActive forKey:NAMES_parkBrakeActive];
}

-(NSNumber*) parkBrakeActive {
    return [store objectForKey:NAMES_parkBrakeActive];
}

-(void) setIgnitionStableStatus:(SDLIgnitionStableStatus*) ignitionStableStatus {
    [store setOrRemoveObject:ignitionStableStatus forKey:NAMES_ignitionStableStatus];
}

-(SDLIgnitionStableStatus*) ignitionStableStatus {
    NSObject* obj = [store objectForKey:NAMES_ignitionStableStatus];
    if ([obj isKindOfClass:SDLIgnitionStableStatus.class]) {
        return (SDLIgnitionStableStatus*)obj;
    } else {
        return [SDLIgnitionStableStatus valueOf:(NSString*)obj];
    }
}

-(void) setIgnitionStatus:(SDLIgnitionStatus*) ignitionStatus {
    [store setOrRemoveObject:ignitionStatus forKey:NAMES_ignitionStatus];
}

-(SDLIgnitionStatus*) ignitionStatus {
    NSObject* obj = [store objectForKey:NAMES_ignitionStatus];
    if ([obj isKindOfClass:SDLIgnitionStatus.class]) {
        return (SDLIgnitionStatus*)obj;
    } else {
        return [SDLIgnitionStatus valueOf:(NSString*)obj];
    }
}

-(void) setDriverDoorAjar:(NSNumber*) driverDoorAjar {
    [store setOrRemoveObject:driverDoorAjar forKey:NAMES_driverDoorAjar];
}

-(NSNumber*) driverDoorAjar {
    return [store objectForKey:NAMES_driverDoorAjar];
}

-(void) setPassengerDoorAjar:(NSNumber*) passengerDoorAjar {
    [store setOrRemoveObject:passengerDoorAjar forKey:NAMES_passengerDoorAjar];
}

-(NSNumber*) passengerDoorAjar {
    return [store objectForKey:NAMES_passengerDoorAjar];
}

-(void) setRearLeftDoorAjar:(NSNumber*) rearLeftDoorAjar {
    [store setOrRemoveObject:rearLeftDoorAjar forKey:NAMES_rearLeftDoorAjar];
}

-(NSNumber*) rearLeftDoorAjar {
    return [store objectForKey:NAMES_rearLeftDoorAjar];
}

-(void) setRearRightDoorAjar:(NSNumber*) rearRightDoorAjar {
    [store setOrRemoveObject:rearRightDoorAjar forKey:NAMES_rearRightDoorAjar];
}

-(NSNumber*) rearRightDoorAjar {
    return [store objectForKey:NAMES_rearRightDoorAjar];
}

@end
