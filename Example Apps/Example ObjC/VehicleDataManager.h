//
//  VehicleDataManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLTriggerSource.h"
@class SDLManager;


NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshUIHandler)(void);

@interface VehicleDataManager : NSObject

@property (copy, nonatomic, readonly) NSString *vehicleOdometerData;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager refreshUIHandler:(RefreshUIHandler)refreshUIHandler;

- (void)subscribeToVehicleOdometer;
- (void)unsubscribeToVehicleOdometer;

+ (void)getAllVehicleDataWithManager:(SDLManager *)manager triggerSource:(SDLTriggerSource)triggerSource vehicleDataType:(NSString *)vehicleDataType;
+ (void)checkPhoneCallCapabilityWithManager:(SDLManager *)manager phoneNumber:(NSString *)phoneNumber;


@end

NS_ASSUME_NONNULL_END
