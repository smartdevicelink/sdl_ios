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

#import "SDLRPCMessage.h"
#import "SDLModuleInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// HMI data struct for HMI control settings
///
/// @since 5.0
@interface SDLHMISettingsControlCapabilities : SDLRPCStruct

/**
 * @param moduleName - moduleName
 * @return A SDLHMISettingsControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName;

/**
 * @param moduleName - moduleName
 * @param moduleInfo - moduleInfo
 * @param distanceUnitAvailable - distanceUnitAvailable
 * @param temperatureUnitAvailable - temperatureUnitAvailable
 * @param displayModeUnitAvailable - displayModeUnitAvailable
 * @return A SDLHMISettingsControlCapabilities object
 */
- (instancetype)initWithModuleNameParam:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo distanceUnitAvailable:(nullable NSNumber<SDLBool> *)distanceUnitAvailable temperatureUnitAvailable:(nullable NSNumber<SDLBool> *)temperatureUnitAvailable displayModeUnitAvailable:(nullable NSNumber<SDLBool> *)displayModeUnitAvailable __deprecated_msg("An initialier without 'param' will eventually be added");

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with moduleName
 
 @param moduleName The short friendly name of the hmi setting module
 @param moduleInfo Information about a RC module, including its id.
 
 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo __deprecated_msg("Use initWithModuleName: instead");

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with given parameters
 
 @param moduleName The short friendly name of the hmi setting module.
 @param moduleInfo Information about a RC module, including its id.
 @param distanceUnitAvailable Availability of the control of distance unit.
 @param temperatureUnitAvailable Availability of the control of temperature unit.
 @param displayModeUnitAvailable Availability of the control of displayMode unit.
 
 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo distanceUnitAvailable:(BOOL)distanceUnitAvailable temperatureUnitAvailable:(BOOL)temperatureUnitAvailable displayModeUnitAvailable:(BOOL)displayModeUnitAvailable __deprecated_msg("An initializer with different parameter types will eventually be added");

/**
 * @abstract The short friendly name of the hmi setting module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Availability of the control of distance unit.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *distanceUnitAvailable;

/**
 * @abstract Availability of the control of temperature unit.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *temperatureUnitAvailable;

/**
 * @abstract  Availability of the control of HMI display mode.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *displayModeUnitAvailable;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
