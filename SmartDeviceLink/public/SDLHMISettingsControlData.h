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
#import "SDLDisplayMode.h"
#import "SDLTemperatureUnit.h"
#import "SDLDistanceUnit.h"

/**
 * Corresponds to "HMI_SETTINGS" ModuleType
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLHMISettingsControlData : SDLRPCStruct

/**
 * @param displayMode - displayMode
 * @param temperatureUnit - temperatureUnit
 * @param distanceUnit - distanceUnit
 * @return A SDLHMISettingsControlData object
 */
- (instancetype)initWithDisplayMode:(nullable SDLDisplayMode)displayMode temperatureUnit:(nullable SDLTemperatureUnit)temperatureUnit distanceUnit:(nullable SDLDistanceUnit)distanceUnit;

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with given parameters

 @param displayMode Display Mode used in HMI setting
 @param temperatureUnit temperature unit used in HMI setting
 @param distanceUnit distance unit used in HMI setting
 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithDisplaymode:(SDLDisplayMode)displayMode temperatureUnit:(SDLTemperatureUnit)temperatureUnit distanceUnit:(SDLDistanceUnit)distanceUnit __deprecated_msg("Use initWithDisplayMode:temperatureUnit:distanceUnit: instead");

/**
 * @abstract Display the Display Mode used HMI setting
 *
 * Optional, SDLDisplayMode
 */
@property (nullable, strong, nonatomic) SDLDisplayMode displayMode;

/**
 * @abstract Display the temperature unit used HMI setting
 *
 * Optional, SDLTemperatureUnit
 */
@property (nullable, strong, nonatomic) SDLTemperatureUnit temperatureUnit;

/**
 * @abstract Display the distance unit used HMI setting
 *
 * Optional, SDLDistanceUnit
 */
@property (nullable, strong, nonatomic) SDLDistanceUnit distanceUnit;

@end

NS_ASSUME_NONNULL_END
