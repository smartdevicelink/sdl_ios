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


#import "SDLRPCStruct.h"
#import "SDLModuleInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Include information about a seat control capabilities.
 */
@interface SDLSeatControlCapabilities : SDLRPCStruct

/**
 * @param moduleName - moduleName
 * @return A SDLSeatControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName;

/**
 * @param moduleName - moduleName
 * @param moduleInfo - moduleInfo
 * @param heatingEnabledAvailable - heatingEnabledAvailable
 * @param coolingEnabledAvailable - coolingEnabledAvailable
 * @param heatingLevelAvailable - heatingLevelAvailable
 * @param coolingLevelAvailable - coolingLevelAvailable
 * @param horizontalPositionAvailable - horizontalPositionAvailable
 * @param verticalPositionAvailable - verticalPositionAvailable
 * @param frontVerticalPositionAvailable - frontVerticalPositionAvailable
 * @param backVerticalPositionAvailable - backVerticalPositionAvailable
 * @param backTiltAngleAvailable - backTiltAngleAvailable
 * @param headSupportHorizontalPositionAvailable - headSupportHorizontalPositionAvailable
 * @param headSupportVerticalPositionAvailable - headSupportVerticalPositionAvailable
 * @param massageEnabledAvailable - massageEnabledAvailable
 * @param massageModeAvailable - massageModeAvailable
 * @param massageCushionFirmnessAvailable - massageCushionFirmnessAvailable
 * @param memoryAvailable - memoryAvailable
 * @return A SDLSeatControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo heatingEnabledAvailable:(nullable NSNumber<SDLBool> *)heatingEnabledAvailable coolingEnabledAvailable:(nullable NSNumber<SDLBool> *)coolingEnabledAvailable heatingLevelAvailable:(nullable NSNumber<SDLBool> *)heatingLevelAvailable coolingLevelAvailable:(nullable NSNumber<SDLBool> *)coolingLevelAvailable horizontalPositionAvailable:(nullable NSNumber<SDLBool> *)horizontalPositionAvailable verticalPositionAvailable:(nullable NSNumber<SDLBool> *)verticalPositionAvailable frontVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)frontVerticalPositionAvailable backVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)backVerticalPositionAvailable backTiltAngleAvailable:(nullable NSNumber<SDLBool> *)backTiltAngleAvailable headSupportHorizontalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportHorizontalPositionAvailable headSupportVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportVerticalPositionAvailable massageEnabledAvailable:(nullable NSNumber<SDLBool> *)massageEnabledAvailable massageModeAvailable:(nullable NSNumber<SDLBool> *)massageModeAvailable massageCushionFirmnessAvailable:(nullable NSNumber<SDLBool> *)massageCushionFirmnessAvailable memoryAvailable:(nullable NSNumber<SDLBool> *)memoryAvailable;

/// Constructs a newly allocated SDLSeatControlCapabilities object with moduleName and moduleInfo
///
/// @param moduleName The short friendly name of the module.
/// @param moduleInfo Information about a RC module, including its id
/// @return An SDLSeatControlCapabilities object
- (instancetype)initWithName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo __deprecated_msg("Use initWithModuleName: instead");

/// Constructs a newly allocated SDLSeatControlCapabilities object with all parameters
///
/// @param moduleName The short friendly name of the module.
/// @param moduleInfo Information about a RC module, including its id
/// @param heatingEnabledAvail Whether or not heating is available
/// @param coolingEnabledAvail Whether or not heating is available
/// @param heatingLevelAvail Whether or not heating level is available
/// @param coolingLevelAvail Whether or not cooling level is available
/// @param horizontalPositionAvail Whether or not horizontal Position is aavailable
/// @param verticalPositionAvail Whether or not vertical position is available
/// @param frontVerticalPositionAvail Whether or not front vertical position is available
/// @param backVerticalPositionAvail Whether or not back vertical position is available
/// @param backTitlAngleAvail Whether or not backTilt angle is available
/// @param headSupportHorizontalPositionAvail Whether or not head supports for horizontal position is available
/// @param headSupportVerticalPositionAvail Whether or not head supports for vertical position is available
/// @param massageEnabledAvail Whether or not massage enabled is available
/// @param massageModeAvail Whether or not massage mode is available
/// @param massageCushionFirmnessAvail Whether or not massage cushion firmness is available
/// @param memoryAvail Whether or not massage cushion firmness is available
/// @return An SDLSeatControlCapabilities object
- (instancetype)initWithName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo heatingEnabledAvailable:(BOOL)heatingEnabledAvail
     coolingEnabledAvailable:(BOOL)coolingEnabledAvail heatingLevelAvailable:(BOOL)heatingLevelAvail coolingLevelAvailable:(BOOL)coolingLevelAvail horizontalPositionAvailable:(BOOL)horizontalPositionAvail verticalPositionAvailable:(BOOL)verticalPositionAvail frontVerticalPositionAvailable:(BOOL)frontVerticalPositionAvail backVerticalPositionAvailable:(BOOL)backVerticalPositionAvail backTiltAngleAvailable:(BOOL)backTitlAngleAvail headSupportHorizontalPositionAvailable:(BOOL)headSupportHorizontalPositionAvail headSupportVerticalPositionAvailable:(BOOL)headSupportVerticalPositionAvail massageEnabledAvailable:(BOOL)massageEnabledAvail massageModeAvailable:(BOOL)massageModeAvail massageCushionFirmnessAvailable:(BOOL)massageCushionFirmnessAvail memoryAvailable:(BOOL)memoryAvail __deprecated_msg("Use another initializer instead");

/**
 * @abstract The short friendly name of the light control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Whether or not heating is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatingEnabledAvailable;

/**
 * @abstract Whether or not cooling is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *coolingEnabledAvailable;

/**
 * @abstract Whether or not heating level is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatingLevelAvailable;

/**
 * @abstract Whether or not cooling level is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *coolingLevelAvailable;

/**
 * @abstract Whether or not horizontal Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *horizontalPositionAvailable;

/**
 * @abstract Whether or not vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *verticalPositionAvailable;

/**
 * @abstract Whether or not front Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *frontVerticalPositionAvailable;

/**
 * @abstract Whether or not back Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *backVerticalPositionAvailable;

/**
 * @abstract Whether or not backTilt Angle Available is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *backTiltAngleAvailable;

/**
 * @abstract Whether or not head Supports for Horizontal Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headSupportHorizontalPositionAvailable;

/**
 * @abstract Whether or not head Supports for Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headSupportVerticalPositionAvailable;

/**
 * @abstract Whether or not massage Enabled is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageEnabledAvailable;

/**
 * @abstract Whether or not massage Mode is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageModeAvailable;

/**
 * @abstract Whether or not massage Cushion Firmness is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageCushionFirmnessAvailable;

/**
 * @abstract Whether or not memory is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *memoryAvailable;

/**
 *  @abstract Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
