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

/**
 * Describes the type and system version of vehicle the mobile phone is connected with.
 *
 * @since SDL 7.1
 */
@interface SDLSystemInfo : NSObject

/**
 * The vehicle type (make, model etc)
 */
@property (strong, nonatomic, readonly) SDLVehicleType *vehicleType;

/**
 * The system software version in format "major.minor.patch"
 * Optional
 */
@property (strong, nonatomic, readonly, nullable) NSString *systemSoftwareVersion;

/**
 * The system hardware version in format "major.minor.patch"
 * Optional
 */
@property (strong, nonatomic, readonly, nullable) NSString *systemHardwareVersion;

/**
 * @param vehicleType - make
 * @param systemSoftwareVersion - model
 * @param systemHardwareVersion - modelYear
 * @return A SDLSystemInfo object
 */
- (instancetype)initWithVehicleType:(SDLVehicleType *)vehicleType systemSoftwareVersion:(NSString *__nullable)systemSoftwareVersion systemHardwareVersion:(NSString *__nullable)systemHardwareVersion;

@end

NS_ASSUME_NONNULL_END
