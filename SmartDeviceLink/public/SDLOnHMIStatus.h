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

#import "SDLRPCNotification.h"

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLSystemContext.h"
#import "SDLVideoStreamingState.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Notifies an application that HMI conditions have changed for the application. This indicates whether the application can speak phrases, display text, perform interactions, receive button presses and events, stream audio, etc. This notification will be sent to the application when there has been a change in any one or several of the indicated states (<i>SDLHMILevel</i>, <i>SDLAudioStreamingState</i> or <i>SDLSystemContext</i>) for the application.

 All three values are, in principle, independent of each other (though there may be some relationships). A value for one parameter should not be interpreted from the value of another parameter.

 There are no guarantees about the timeliness or latency of the SDLOnHMIStatus notification. Therefore, for example, information such as <i>SDLAudioStreamingState</i> may not indicate that the audio stream became inaudible to the user exactly when the SDLOnHMIStatus notification was received.

 @since SDL 1.0
 */
@interface SDLOnHMIStatus : SDLRPCNotification

/**
 * @param hmiLevel - hmiLevel
 * @param audioStreamingState - audioStreamingState
 * @param systemContext - systemContext
 * @return A SDLOnHMIStatus object
 */
- (instancetype)initWithHmiLevel:(SDLHMILevel)hmiLevel audioStreamingState:(SDLAudioStreamingState)audioStreamingState systemContext:(SDLSystemContext)systemContext;

/**
 * @param hmiLevel - hmiLevel
 * @param audioStreamingState - audioStreamingState
 * @param systemContext - systemContext
 * @param videoStreamingState - videoStreamingState
 * @param windowID - windowID
 * @return A SDLOnHMIStatus object
 */
- (instancetype)initWithHmiLevel:(SDLHMILevel)hmiLevel audioStreamingState:(SDLAudioStreamingState)audioStreamingState systemContext:(SDLSystemContext)systemContext videoStreamingState:(nullable SDLVideoStreamingState)videoStreamingState windowID:(nullable NSNumber<SDLInt> *)windowID;

/// Initialize an SDLOnHMIStatus RPC with initial parameters
/// @param hmiLevel The HMI level
/// @param systemContext The system context
/// @param audioStreamingState The ability for an audio app to be heard
/// @param videoStreamingState The ability for a video straming app to stream
/// @param windowID Which window this status relates to
- (instancetype)initWithHMILevel:(SDLHMILevel)hmiLevel systemContext:(SDLSystemContext)systemContext audioStreamingState:(SDLAudioStreamingState)audioStreamingState videoStreamingState:(nullable SDLVideoStreamingState)videoStreamingState windowID:(nullable NSNumber<SDLUInt> *)windowID __deprecated_msg("Use initWithHmiLevel:audioStreamingState:systemContext:videoStreamingState:windowID: instead");

/**
 SDLHMILevel in effect for the application
 */
@property (strong, nonatomic) SDLHMILevel hmiLevel;

/**
 Current state of audio streaming for the application. When this parameter has a value of NOT_AUDIBLE, the application must stop streaming audio to SDL.

 Informs app whether any currently streaming audio is audible to user (AUDIBLE) or not (NOT_AUDIBLE). A value of NOT_AUDIBLE means that either the application's audio will not be audible to the user, or that the application's audio should not be audible to the user (i.e. some other application on the mobile device may be streaming audio and the application's audio would be blended with that other audio).
 */
@property (strong, nonatomic) SDLAudioStreamingState audioStreamingState;

/**
 Current availablility of video streaming for the application. When this parameter is NOT_STREAMABLE, the application must stop video streaming to SDL.
 */
@property (strong, nonatomic, nullable) SDLVideoStreamingState videoStreamingState;

/**
 Whether a user-initiated interaction is in-progress (VRSESSION or MENU), or not (MAIN)
 */
@property (strong, nonatomic) SDLSystemContext systemContext;

/**
 This is the unique ID assigned to the window that this RPC is intended for. If this param is not included, it will be assumed that this request is specifically for the main window on the main display. @see PredefinedWindows enum.
 
 @since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLUInt> *windowID;

@end

NS_ASSUME_NONNULL_END
