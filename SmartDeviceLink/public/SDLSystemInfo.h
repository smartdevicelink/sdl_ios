//
//  SDLSystemInfo.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/23/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLVehicleType;

NS_ASSUME_NONNULL_BEGIN

/// Basic information about the connected module system
@interface SDLSystemInfo : NSObject

/// The connected module's vehicle type: it's make, model, trim, and model year
@property (strong, nonatomic, readonly, nullable) SDLVehicleType *vehicleType;

/// The connected module's software version
@property (strong, nonatomic, readonly, nullable) NSString *systemSoftwareVersion;

/// The connected module's hardware version
@property (strong, nonatomic, readonly, nullable) NSString *systemHardwareVersion;

/// Initialize a system info object with individual pieces
/// @param make The vehicle's make
/// @param model The vehicle's model
/// @param trim The vehicle's trim
/// @param modelYear The vehicle's model year
/// @param softwareVersion The vehicle's software version
/// @param hardwareVersion The vehicle's hardware version
- (instancetype)initWithMake:(nullable NSString *)make model:(nullable NSString *)model trim:(nullable NSString *)trim modelYear:(nullable NSString *)modelYear softwareVersion:(nullable NSString *)softwareVersion hardwareVersion:(nullable NSString *)hardwareVersion;

/// Initialize a system info object with the vehicle type and versions
/// @param vehicleType The vehicle information
/// @param softwareVersion The vehicle's software version
/// @param hardwareVersion The vehicle's hardware version
- (instancetype)initWithVehicleType:(nullable SDLVehicleType *)vehicleType softwareVersion:(nullable NSString *)softwareVersion hardwareVersion:(nullable NSString *)hardwareVersion;

@end

NS_ASSUME_NONNULL_END
