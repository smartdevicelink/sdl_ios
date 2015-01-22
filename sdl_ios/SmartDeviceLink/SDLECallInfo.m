//  SDLECallInfo.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLECallInfo.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLECallInfo

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setECallNotificationStatus:(SDLVehicleDataNotificationStatus*) eCallNotificationStatus {
    [store setOrRemoveObject:eCallNotificationStatus forKey:NAMES_eCallNotificationStatus];
}

-(SDLVehicleDataNotificationStatus*) eCallNotificationStatus {
    NSObject* obj = [store objectForKey:NAMES_eCallNotificationStatus];
    if ([obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus*)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString*)obj];
    }
}

-(void) setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus*) auxECallNotificationStatus {
    [store setOrRemoveObject:auxECallNotificationStatus forKey:NAMES_auxECallNotificationStatus];
}

-(SDLVehicleDataNotificationStatus*) auxECallNotificationStatus {
    NSObject* obj = [store objectForKey:NAMES_auxECallNotificationStatus];
    if ([obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus*)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString*)obj];
    }
}

-(void) setECallConfirmationStatus:(SDLECallConfirmationStatus*) eCallConfirmationStatus {
    [store setOrRemoveObject:eCallConfirmationStatus forKey:NAMES_eCallConfirmationStatus];
}

-(SDLECallConfirmationStatus*) eCallConfirmationStatus {
    NSObject* obj = [store objectForKey:NAMES_eCallConfirmationStatus];
    if ([obj isKindOfClass:SDLECallConfirmationStatus.class]) {
        return (SDLECallConfirmationStatus*)obj;
    } else {
        return [SDLECallConfirmationStatus valueOf:(NSString*)obj];
    }
}

@end
