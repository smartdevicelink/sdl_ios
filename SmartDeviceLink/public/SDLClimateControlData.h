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
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"

NS_ASSUME_NONNULL_BEGIN

@class SDLTemperature;


/**
 The current information for the Climate Remote Control Module
 */
@interface SDLClimateControlData : SDLRPCStruct

/**
 * @param fanSpeed - fanSpeed
 * @param currentTemperature - currentTemperature
 * @param desiredTemperature - desiredTemperature
 * @param acEnable - acEnable
 * @param circulateAirEnable - circulateAirEnable
 * @param autoModeEnable - autoModeEnable
 * @param defrostZone - defrostZone
 * @param dualModeEnable - dualModeEnable
 * @param acMaxEnable - acMaxEnable
 * @param ventilationMode - ventilationMode
 * @param heatedSteeringWheelEnable - heatedSteeringWheelEnable
 * @param heatedWindshieldEnable - heatedWindshieldEnable
 * @param heatedRearWindowEnable - heatedRearWindowEnable
 * @param heatedMirrorsEnable - heatedMirrorsEnable
 * @param climateEnable - climateEnable
 * @return A SDLClimateControlData object
 */
- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLUInt> *)fanSpeed currentTemperature:(nullable SDLTemperature *)currentTemperature desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode heatedSteeringWheelEnable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable heatedWindshieldEnable:(nullable NSNumber<SDLBool> *)heatedWindshieldEnable heatedRearWindowEnable:(nullable NSNumber<SDLBool> *)heatedRearWindowEnable heatedMirrorsEnable:(nullable NSNumber<SDLBool> *)heatedMirrorsEnable climateEnable:(nullable NSNumber<SDLBool> *)climateEnable;

/// Convenience init for climate control data with all properties.
/// @param fanSpeed Speed of Fan in integer
/// @param desiredTemperature Desired Temperature in SDLTemperature
/// @param acEnable Represents if AC is enabled
/// @param circulateAirEnable Represents if circulation of air is enabled
/// @param autoModeEnable Represents if auto mode is enabled
/// @param defrostZone Represents the kind of defrost zone
/// @param dualModeEnable Represents if dual mode is enabled
/// @param acMaxEnable Represents if ac max is enabled
/// @param ventilationMode Represents the kind of ventilation zone
/// @param heatedSteeringWheelEnable Represents if heated steering wheel is enabled
/// @param heatedWindshieldEnable Represents if heated windshield is enabled
/// @param heatedRearWindowEnable Represents if heated rear window is enabled
/// @param heatedMirrorsEnable Represents if heated mirrors are enabled
/// @param climateEnable Represents if climate is enabled
/// @return An SDLClimateControlData object
- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode heatedSteeringWheelEnable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable heatedWindshieldEnable:(nullable NSNumber<SDLBool> *)heatedWindshieldEnable heatedRearWindowEnable:(nullable NSNumber<SDLBool> *)heatedRearWindowEnable heatedMirrorsEnable:(nullable NSNumber<SDLBool> *)heatedMirrorsEnable climateEnable:(nullable NSNumber<SDLBool> *)climateEnable __deprecated_msg("Use initWithFanSpeed:currentTemperature:desiredTemperature:acEnable:circulateAirEnable:autoModeEnable:defrostZone:dualModeEnable:acMaxEnable:ventilationMode:heatedSteeringWheelEnable:heatedWindshieldEnable:heatedRearWindowEnable:heatedMirrorsEnable:climateEnable:");

/**
 * Speed of Fan in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *fanSpeed;

/**
 * The Current Temperature in SDLTemperature
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *currentTemperature;

/**
 * Desired Temperature in SDLTemperature
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *desiredTemperature;

/**
 * Represents if AC is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acEnable;

/**
 * Represents if circulation of air is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *circulateAirEnable;

/**
 * Represents if auto mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *autoModeEnable;

/**
 * Represents the kind of defrost zone.
 *
 * Optional, SDLDefrostZone
 */
@property (nullable, strong, nonatomic) SDLDefrostZone defrostZone;

/**
 * Represents if dual mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *dualModeEnable;

/**
 * Represents if ac max is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acMaxEnable;

/**
 * Represents the kind of Ventilation zone.
 *
 * Optional, SDLVentilationMode
 */
@property (nullable, strong, nonatomic) SDLVentilationMode ventilationMode;

/**
 * @abstract value false means disabled/turn off, value true means enabled/turn on.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedSteeringWheelEnable;

/**
 * @abstract value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedWindshieldEnable;

/**
 * @abstract value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedRearWindowEnable;

/**
 * @abstract Value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedMirrorsEnable;

/**
 * @abstract Value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *climateEnable;

@end

NS_ASSUME_NONNULL_END
