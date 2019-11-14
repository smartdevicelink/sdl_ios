//
//  SDLReleaseInteriorVehicleDataModule.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"

NS_ASSUME_NONNULL_BEGIN

/// Releases a controlled remote control module so others can take control
///
/// @since 6.0
@interface SDLReleaseInteriorVehicleDataModule : SDLRPCRequest

/// Convenience init to release a controlled module
/// @param moduleType The module type that the app requests to control.
/// @param moduleId Id of a module, published by System Capability.
/// @return An SDLReleaseInteriorVehicleDataModule object
- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId;

/**
 * The module type that the app requests to control.
 *
 * Required
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 * Id of a module, published by System Capability.
 *
 * Optional
 */
@property (strong, nonatomic, nullable) NSString *moduleId;

@end

NS_ASSUME_NONNULL_END
