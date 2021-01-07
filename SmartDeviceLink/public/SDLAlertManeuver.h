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

@class SDLSoftButton;
@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Shows a SDLShowConstantTBT message with an optional voice command. This message is shown as an overlay over the display's base screen.
 *
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest

///  Convenience init to create an alert maneuver with all parameters
///
/// @param ttsChunks An array of text chunks
/// @param softButtons An arry of soft buttons
/// @return An SDLAlertManeuver object
- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

/// Convenience init to create an alert maneuver with required parameters
///
/// @param ttsText The text to speak
/// @param softButtons An arry of soft buttons
///
/// @return An SDLAlertManeuver object
- (instancetype)initWithTTS:(nullable NSString *)ttsText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons __deprecated_msg("Use initWithTTSChunks:softButtons: instead");

/**
 *  An array of text chunks.
 *
 *  Optional, Array of SDLTTSChunk, Array length 1 - 100
 *
 *  @see SDLTTSChunk
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *ttsChunks;

/**
 *  An arry of soft buttons. If omitted on supported displays, only the system defined "Close" SoftButton shall be displayed.
 *
 *  Optional, Array of SDLSoftButton, Array length 0 - 3
 *
 *  @see SDLSoftButton
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
