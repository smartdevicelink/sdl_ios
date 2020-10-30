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

@class  SDLAudioControlCapabilities;
@class  SDLButtonCapabilities;
@class  SDLClimateControlCapabilities;
@class  SDLHMISettingsControlCapabilities;
@class  SDLLightControlCapabilities;
@class  SDLRadioControlCapabilities;
@class  SDLSeatControlCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 Capabilities of the remote control feature

 @added in SmartDeviceLink 4.5.0
 */
@interface SDLRemoteControlCapabilities : SDLRPCStruct

/**
 * @param climateControlCapabilities - climateControlCapabilities
 * @param radioControlCapabilities - radioControlCapabilities
 * @param buttonCapabilities - buttonCapabilities
 * @param audioControlCapabilities - audioControlCapabilities
 * @param hmiSettingsControlCapabilities - hmiSettingsControlCapabilities
 * @param lightControlCapabilities - lightControlCapabilities
 * @param seatControlCapabilities - seatControlCapabilities
 * @return A SDLRemoteControlCapabilities object
 */
- (instancetype)initWithClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities audioControlCapabilities:(nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities hmiSettingsControlCapabilities:(nullable SDLHMISettingsControlCapabilities *)hmiSettingsControlCapabilities lightControlCapabilities:(nullable SDLLightControlCapabilities *)lightControlCapabilities seatControlCapabilities:(nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities;

/**
 Constructs a newly allocated SDLRemoteControlCapabilities object with given parameters
 
 @param climateControlCapabilities Array of SDLClimateControlCapabilities
 @param radioControlCapabilities Array of SDLRadioControlCapabilities
 @param buttonCapabilities Array of SDLButtonCapabilities
 @param lightControlCapabilities Array of SDLLightControlCapabilities
 @param seatControlCapabilities Array of SDLSeatControlCapabilities

 @return An instance of the SDLRemoteControlCapabilities class
 */
- (instancetype)initWithClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities seatControlCapabilities:(nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities audioControlCapabilities:(nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities hmiSettingsControlCapabilities:(nullable NSArray<SDLHMISettingsControlCapabilities *> *)hmiSettingsControlCapabilities lightControlCapabilities:(nullable NSArray<SDLLightControlCapabilities *> *)lightControlCapabilities __deprecated_msg("Use another initializer");

/**
 * If included, the platform supports RC climate controls.
 * For this baseline version, maxsize=1. i.e. only one climate control module is supported.
 *
 * Optional, Array of SDLClimateControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLClimateControlCapabilities *> *climateControlCapabilities;

/**
 * If included, the platform supports RC radio controls.
 * For this baseline version, maxsize=1. i.e. only one radio control module is supported.
 *
 * Optional, Array of SDLRadioControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLRadioControlCapabilities *> *radioControlCapabilities;

/**
 * If included, the platform supports RC button controls with the included button names.
 *
 * Optional, Array of SDLButtonCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 * If included, the platform supports seat controls.
 *
 * Optional, Array of SDLSeatControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLSeatControlCapabilities *> *seatControlCapabilities;

/**
 * If included, the platform supports audio controls.
 *
 * Optional, Array of SDLAudioControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLAudioControlCapabilities *> *audioControlCapabilities;

/**
 * If included, the platform supports hmi setting controls.
 *
 * Optional, Array of SDLHMISettingsControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLHMISettingsControlCapabilities *> *hmiSettingsControlCapabilities __deprecated_msg("Use hmiSettingsControlCapabilities instead");

/**
 * If included, the platform supports light controls.
 *
 * Optional, Array of SDLLightControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLLightControlCapabilities *> *lightControlCapabilities __deprecated_msg("Use hmiSettingsControlCapabilities instead");

/**
 * If included, the platform supports hmi setting controls.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLHMISettingsControlCapabilities *hmiSettingsControlCapabilitiesParam __deprecated_msg("Eventually this parameter will be replaced without the param");

/**
 * If included, the platform supports light controls.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLLightControlCapabilities *lightControlCapabilitiesParam __deprecated_msg("Eventually this parameter will be replaced without the param");

@end

NS_ASSUME_NONNULL_END
