/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"
#import "SDLModuleInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Reads the current status value of specified remote control module (type).
 * When subscribe is true, subscribes for specific remote control module data items.
 * When subscribe is false, unsubscribes for specific remote control module data items.
 * Once subscribed, the application will be notified by the onInteriorVehicleData RPC notification
 * whenever new data is available for the module.
 */
@interface SDLGetInteriorVehicleData : SDLRPCRequest

/**
 * @param moduleType - moduleType
 * @return A SDLGetInteriorVehicleData object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType;

/**
 * @param moduleType - moduleType
 * @param moduleId - moduleId
 * @param subscribe - subscribe
 * @return A SDLGetInteriorVehicleData object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(nullable NSString *)moduleId subscribe:(nullable NSNumber<SDLBool> *)subscribe;

/// Convenience init to get information of a particular module type with a module ID.
///
/// @param moduleType The type of a RC module to retrieve module data from the vehicle
/// @param moduleId Id of a module, published by System Capability
/// @return An SDLGetInteriorVehicleData object
- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId __deprecated_msg("Use initWithModuleType:moduleId:subscribe: instead");

/// Convenience init to get information and subscribe to a particular module type with a module ID.
///
/// @param moduleType The type of a RC module to retrieve module data from the vehicle
/// @param moduleId Id of a module, published by System Capability
/// @return An SDLGetInteriorVehicleData object
- (instancetype)initAndSubscribeToModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId __deprecated_msg("Use initWithModuleType:moduleId:subscribe: instead");

/// Convenience init to unsubscribe from particular module with a module ID.
///
/// @param moduleType The type of a RC module to retrieve module data from the vehicle
/// @param moduleId Id of a module, published by System Capability
/// @return An SDLGetInteriorVehicleData object
- (instancetype)initAndUnsubscribeToModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId __deprecated_msg("Use initWithModuleType:moduleId:subscribe: instead");

/**
 * The type of a RC module to retrieve module data from the vehicle.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 *  Id of a module, published by System Capability.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * If subscribe is true, the head unit will register OnInteriorVehicleData notifications for the requested module (moduleId and moduleType).
 * If subscribe is false, the head unit will unregister OnInteriorVehicleData notifications for the requested module (moduleId and moduleType).
 * If subscribe is not included, the subscription status of the app for the requested module (moduleId and moduleType) will remain unchanged.
 *
 * optional, Boolean, default Value = false
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
