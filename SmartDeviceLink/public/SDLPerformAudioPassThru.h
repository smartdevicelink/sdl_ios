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

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLNotificationConstants.h"
#import "SDLSamplingRate.h"

@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

/**
 * This will open an audio pass thru session. By doing so the app can receive
 * audio data through the vehicle microphone
 * <p>
 * Function Group: AudioPassThru
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * <p>Since SmartDeviceLink 2.0</p>
 * <p>See SDLEndAudioPassThru</p>
 */
@interface SDLPerformAudioPassThru : SDLRPCRequest

/**
 * @param samplingRate - samplingRate
 * @param maxDuration - @(maxDuration)
 * @param bitsPerSample - bitsPerSample
 * @param audioType - audioType
 * @return A SDLPerformAudioPassThru object
 */
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate maxDuration:(UInt32)maxDuration bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType;

/**
 * @param samplingRate - samplingRate
 * @param maxDuration - @(maxDuration)
 * @param bitsPerSample - bitsPerSample
 * @param audioType - audioType
 * @param initialPrompt - initialPrompt
 * @param audioPassThruDisplayText1 - audioPassThruDisplayText1
 * @param audioPassThruDisplayText2 - audioPassThruDisplayText2
 * @param muteAudio - muteAudio
 * @return A SDLPerformAudioPassThru object
 */
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate maxDuration:(UInt32)maxDuration bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 muteAudio:(nullable NSNumber<SDLBool> *)muteAudio;

/// Convenience init to perform an audio pass thru
///
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration __deprecated_msg("Use initWithSamplingRate:maxDuration:bitsPerSample:audioType: instead");

/// Convenience init to perform an audio pass thru
///
/// @param initialPrompt Initial prompt which will be spoken before opening the audio pass thru session by SDL
/// @param audioPassThruDisplayText1 A line of text displayed during audio capture
/// @param audioPassThruDisplayText2 A line of text displayed during audio capture
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param muteAudio A Boolean value representing if the current audio source should be muted during the APT session
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio __deprecated_msg("Use initWithSamplingRate:maxDuration:bitsPerSample:audioType: instead");

/// Convenience init to perform an audio pass thru
///
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param audioDataHandler A handler that will be called whenever an onAudioPassThru notification is received.
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler __deprecated_msg("Use initWithSamplingRate:maxDuration:bitsPerSample:audioType: instead");

/// Convenience init for a perform audio pass thru
///
// @param initialPrompt Initial prompt which will be spoken before opening the audio pass thru session by SDL
/// @param audioPassThruDisplayText1 A line of text displayed during audio capture
/// @param audioPassThruDisplayText2 A line of text displayed during audio capture
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param muteAudio A Boolean value representing if the current audio source should be muted during the APT session
/// @param audioDataHandler A handler that will be called whenever an onAudioPassThru notification is received.
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler __deprecated_msg("Use initWithSamplingRate:maxDuration:bitsPerSample:audioType: instead");
    
/**
 * initial prompt which will be spoken before opening the audio pass
 * thru session by SDL
 * @discussion initialPrompt
 *            a Vector<TTSChunk> value represents the initial prompt which
 *            will be spoken before opening the audio pass thru session by
 *            SDL
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>This is an array of text chunks of type TTSChunk</li>
 *            <li>The array must have at least one item</li>
 *            <li>If omitted, then no initial prompt is spoken</li>
 *            <li>Array Minsize: 1</li>
 *            <li>Array Maxsize: 100</li>
 *            </ul>
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *initialPrompt;
/**
 * a line of text displayed during audio capture
 * @discussion audioPassThruDisplayText1
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (nullable, strong, nonatomic) NSString *audioPassThruDisplayText1;
/**
 * A line of text displayed during audio capture
 * @discussion audioPassThruDisplayText2
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (nullable, strong, nonatomic) NSString *audioPassThruDisplayText2;
/**
 * A samplingRate
 *
 * @discussion a SamplingRate value representing a 8 or 16 or 22 or 24 khz
 */
@property (strong, nonatomic) SDLSamplingRate samplingRate;
/**
 * the maximum duration of audio recording in milliseconds
 *
 * @discussion maxDuration
 *            an Integer value representing the maximum duration of audio
 *            recording in millisecond
 *            <p>
 *            <b>Notes: </b>Minvalue:1; Maxvalue:1000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maxDuration;
/**
 * the quality the audio is recorded - 8 bit or 16 bit
 *
 * @discussion a BitsPerSample value representing 8 bit or 16 bit
 */
@property (strong, nonatomic) SDLBitsPerSample bitsPerSample;
/**
 * an audioType
 */
@property (strong, nonatomic) SDLAudioType audioType;
/**
 * a Boolean value representing if the current audio source should be
 * muted during the APT session<br/>
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *muteAudio;
    
/**
 *  A handler that will be called whenever an `onAudioPassThru` notification is received.
 */
@property (strong, nonatomic, nullable) SDLAudioPassThruHandler audioDataHandler;


@end

NS_ASSUME_NONNULL_END
