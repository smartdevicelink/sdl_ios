//
//  SDLSystemInfo.h
//  SmartDeviceLink
//
//  Created by YL on 01.02.2021.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLVehicleType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemInfo : NSObject

@property (strong, nonatomic, readonly) SDLVehicleType *vehicleType;
@property (strong, nonatomic, readonly, nullable) NSString *systemSoftwareVersion;
@property (strong, nonatomic, readonly, nullable) NSString *systemHardwareVersion;

- (instancetype)initWithVehicleType:(SDLVehicleType *)vehicleType systemSoftwareVersion:(NSString *__nullable)systemSoftwareVersion systemHardwareVersion:(NSString *__nullable)systemHardwareVersion;

@end

NS_ASSUME_NONNULL_END
