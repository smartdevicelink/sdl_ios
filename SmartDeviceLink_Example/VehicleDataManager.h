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

typedef void(^RefreshUIHandler)(void);

@interface VehicleDataManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager refreshUIHandler:(RefreshUIHandler)refreshUIHandler;
- (void)stopManager;

- (void)subscribeToVehicleOdometer;
- (void)unsubscribeToVehicleOdometer;

+ (void)getVehicleSpeedWithManager:(SDLManager *)manager;
+ (void)checkPhoneCallCapabilityWithManager:(SDLManager *)manager phoneNumber:(NSString *)phoneNumber;


@end

NS_ASSUME_NONNULL_END
