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

/**
 Describes a head unit's audio control capabilities.

 @since RPC 5.0
 */
@interface SDLAudioControlCapabilities : SDLRPCStruct

/**
 * @param moduleName - moduleName
 * @return A SDLAudioControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName;

/**
 * @param moduleName - moduleName
 * @param moduleInfo - moduleInfo
 * @param sourceAvailable - sourceAvailable
 * @param keepContextAvailable - keepContextAvailable
 * @param volumeAvailable - volumeAvailable
 * @param equalizerAvailable - equalizerAvailable
 * @param equalizerMaxChannelId - equalizerMaxChannelId
 * @return A SDLAudioControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable keepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable volumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelId:(nullable NSNumber<SDLUInt> *)equalizerMaxChannelId;

/**
 Constructs a newly allocated SDLAudioControlCapabilities object with audio control module name (max 100 chars)
 
 @param name The short friendly name of the audio control module.
 @param moduleInfo Information about a RC module, including its id.
 @return An instance of the SDLAudioControlCapabilities class.
 */
- (instancetype)initWithModuleName:(NSString *)name moduleInfo:(nullable SDLModuleInfo *)moduleInfo __deprecated_msg("Use initWithModuleName: instead");

/**
 Constructs a newly allocated SDLAudioControlCapabilities object with given parameters
 
 @param name The short friendly name of the audio control module.
 @param moduleInfo Information about a RC module, including its id.
 @param sourceAvailable Availability of the control of audio source.
 @param volumeAvailable Availability of the volume of audio source.
 @param equalizerAvailable Availability of the equalizer of audio source.
 @param equalizerMaxChannelID Equalizer channel ID (between 1-100).
 @return An instance of the SDLAudioControlCapabilities class.
 */
- (instancetype)initWithModuleName:(NSString *)name moduleInfo:(nullable SDLModuleInfo *)moduleInfo sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable keepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable volumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)equalizerMaxChannelID __deprecated_msg("Use initWithModuleName: instead");

/**
 * @abstract The short friendly name of the audio control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Availability of the control of audio source.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *sourceAvailable;

/**
 Availability of the keepContext parameter.

 Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *keepContextAvailable;

/**
 * @abstract Availability of the control of audio volume.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *volumeAvailable;

/**
 * @abstract Availability of the control of Equalizer Settings.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *equalizerAvailable;

/**
 * @abstract Must be included if equalizerAvailable=true,
 * and assume all IDs starting from 1 to this value are valid
 *
 * Optional, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *equalizerMaxChannelId;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
