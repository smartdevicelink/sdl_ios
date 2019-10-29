//
//  SDLGetInteriorVehicleDataConsent.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"

NS_ASSUME_NONNULL_BEGIN


/// This RPC allows you to get consent to control a certian module
///
/// @since RPC 6.0
@interface SDLGetInteriorVehicleDataConsent : SDLRPCRequest

/// Convenience init to get consent to control a module
///
/// @param moduleType The module type that the app requests to control
/// @param moduleIds Ids of a module of same type, published by System Capability
/// @return An SDLGetInteriorVehicleDataConsent object
- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleIds:(NSArray<NSString *> *)moduleIds;

/**
 * The module type that the app requests to control.
 *
 * Required
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 * Ids of a module of same type, published by System Capability.
 *
 * Required
 */
@property (strong, nonatomic) NSArray<NSString *> *moduleIds;

@end

NS_ASSUME_NONNULL_END
