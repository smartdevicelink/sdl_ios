//  SDLClusterModeStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLClusterModeStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLClusterModeStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setPowerModeActive:(NSNumber*) powerModeActive {
    [store setOrRemoveObject:powerModeActive forKey:NAMES_powerModeActive];
}

-(NSNumber*) powerModeActive {
    return [store objectForKey:NAMES_powerModeActive];
}

-(void) setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus*) powerModeQualificationStatus {
    [store setOrRemoveObject:powerModeQualificationStatus forKey:NAMES_powerModeQualificationStatus];
}

-(SDLPowerModeQualificationStatus*) powerModeQualificationStatus {
    NSObject* obj = [store objectForKey:NAMES_powerModeQualificationStatus];
    if ([obj isKindOfClass:SDLPowerModeQualificationStatus.class]) {
        return (SDLPowerModeQualificationStatus*)obj;
    } else {
        return [SDLPowerModeQualificationStatus valueOf:(NSString*)obj];
    }
}

-(void) setCarModeStatus:(SDLCarModeStatus*) carModeStatus {
    [store setOrRemoveObject:carModeStatus forKey:NAMES_carModeStatus];
}

-(SDLCarModeStatus*) carModeStatus {
    NSObject* obj = [store objectForKey:NAMES_carModeStatus];
    if ([obj isKindOfClass:SDLCarModeStatus.class]) {
        return (SDLCarModeStatus*)obj;
    } else {
        return [SDLCarModeStatus valueOf:(NSString*)obj];
    }
}

-(void) setPowerModeStatus:(SDLPowerModeStatus*) powerModeStatus {
    [store setOrRemoveObject:powerModeStatus forKey:NAMES_powerModeStatus];
}

-(SDLPowerModeStatus*) powerModeStatus {
    NSObject* obj = [store objectForKey:NAMES_powerModeStatus];
    if ([obj isKindOfClass:SDLPowerModeStatus.class]) {
        return (SDLPowerModeStatus*)obj;
    } else {
        return [SDLPowerModeStatus valueOf:(NSString*)obj];
    }
}

@end
