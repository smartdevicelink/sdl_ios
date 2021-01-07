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
#import "SDLPrimaryAudioSource.h"

@class SDLEqualizerSettings;

NS_ASSUME_NONNULL_BEGIN

/**
 The audio control data information.

 @since RPC 5.0
 */
@interface SDLAudioControlData : SDLRPCStruct

/**
 Constructs a newly allocated SDLAudioControlData object with given parameters

 @param source current primary audio source of the system.
 @param keepContext Whether or not application's context is changed.
 @param volume Reflects the volume of audio.
 @param equalizerSettings list of supported Equalizer channels.
 @return An instance of the SDLAudioControlData class.
 */
- (instancetype)initWithSource:(nullable SDLPrimaryAudioSource)source keepContext:(nullable NSNumber<SDLBool> *)keepContext volume:(nullable NSNumber<SDLUInt> *)volume equalizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings;

/**
 * @abstract   In a getter response or a notification,
 * it is the current primary audio source of the system.
 * In a setter request, it is the target audio source that the system shall switch to.
 * If the value is MOBILE_APP, the system shall switch to the mobile media app that issues the setter RPC.
 *
 * Optional, SDLPrimaryAudioSource
 */
@property (nullable, strong, nonatomic) SDLPrimaryAudioSource source;

/**
 * @abstract This parameter shall not be present in any getter responses or notifications.
 * This parameter is optional in a setter request. The default value is false.
 * If it is true, the system not only changes the audio source but also brings the default
 * infotainment system UI associated with the audio source to foreground and set the application to background.
 * If it is false, the system changes the audio source, but keeps the current application's context.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *keepContext;

/**
 * @abstract Reflects the volume of audio, from 0%-100%.
 *
 * Required, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *volume;

/**
 * @abstract Defines the list of supported channels (band) and their current/desired settings on HMI
 *
 * Required, Array of SDLEqualizerSettings with minSize:1 maxSize:100
 */
@property (nullable, strong, nonatomic) NSArray<SDLEqualizerSettings *> *equalizerSettings;

@end

NS_ASSUME_NONNULL_END
