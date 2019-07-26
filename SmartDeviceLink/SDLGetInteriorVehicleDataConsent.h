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

@interface SDLGetInteriorVehicleDataConsent : SDLRPCRequest

- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleIds:(NSArray<NSString *> *)moduleIds;

/**
 * The module type that the app requests to control.
 *
 * Required
 */
@property (strong, nonatomic, nullable) SDLModuleType moduleType;

/**
 * Ids of a module of same type, published by System Capability.
 *
 * Required
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *moduleIds;

@end

NS_ASSUME_NONNULL_END
