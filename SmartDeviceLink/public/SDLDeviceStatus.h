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

#import "SDLDeviceLevelStatus.h"
#import "SDLPrimaryAudioSource.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Describes the status related to a connected mobile device or SDL and if or how  it is represented in the vehicle.

 @since SDL 2.0
 */
@interface SDLDeviceStatus : SDLRPCStruct

/**
 * @param voiceRecOn - @(voiceRecOn)
 * @param btIconOn - @(btIconOn)
 * @param callActive - @(callActive)
 * @param phoneRoaming - @(phoneRoaming)
 * @param textMsgAvailable - @(textMsgAvailable)
 * @param battLevelStatus - battLevelStatus
 * @param stereoAudioOutputMuted - @(stereoAudioOutputMuted)
 * @param monoAudioOutputMuted - @(monoAudioOutputMuted)
 * @param signalLevelStatus - signalLevelStatus
 * @param primaryAudioSource - primaryAudioSource
 * @param eCallEventActive - @(eCallEventActive)
 * @return A SDLDeviceStatus object
 */
- (instancetype)initWithVoiceRecOn:(BOOL)voiceRecOn btIconOn:(BOOL)btIconOn callActive:(BOOL)callActive phoneRoaming:(BOOL)phoneRoaming textMsgAvailable:(BOOL)textMsgAvailable battLevelStatus:(SDLDeviceLevelStatus)battLevelStatus stereoAudioOutputMuted:(BOOL)stereoAudioOutputMuted monoAudioOutputMuted:(BOOL)monoAudioOutputMuted signalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus primaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource eCallEventActive:(BOOL)eCallEventActive;

/**
 * Indicates whether the voice recognition is on or off
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *voiceRecOn;

/**
 * Indicates whether the bluetooth connection established
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *btIconOn;

/**
 * Indicates whether a call is being active
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *callActive;

/**
 * Indicates whether the phone is in roaming mode
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *phoneRoaming;

/**
 * Indicates whether a textmessage is available
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *textMsgAvailable;

/**
 * Battery level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong, nonatomic) SDLDeviceLevelStatus battLevelStatus;

/**
 * The status of the stereo audio output channel
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *stereoAudioOutputMuted;

/**
 * The status of the mono audio output channel
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *monoAudioOutputMuted;

/**
 * Signal level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong, nonatomic) SDLDeviceLevelStatus signalLevelStatus;

/**
 * The current primary audio source of SDL (if selected).
 *
 * @see SDLPrimaryAudioSource
 * 
 * Required
 */
@property (strong, nonatomic) SDLPrimaryAudioSource primaryAudioSource;

/**
 * Indicates if an emergency call is active
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *eCallEventActive;

@end

NS_ASSUME_NONNULL_END
