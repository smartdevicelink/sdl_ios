//
//  VehicleDataManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;

NS_ASSUME_NONNULL_BEGIN

@interface VehicleDataManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager;

- (void)subscribeToVehicleOdometer;
- (void)unsubscribeToVehicleOdometer;

+ (void)getVehicleSpeedWithManager:(SDLManager *)manager;
+ (void)checkPhoneCallCapabilityWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
