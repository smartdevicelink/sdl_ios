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

@class SDLImage;
@class SDLSoftButton;
@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

/**
 Shows an alert which typically consists of text-to-speech message and text on the display. Either `alertText1`, `alertText2` or `TTSChunks` needs to be set or the request will be rejected.

 If connecting to SDL Core v.6.0+, the alert can be canceled programmatically using the `cancelID`. Canceling will not dismiss the alert's speech - only the modal view will be dismissed. On older versions of SDL Core, the alert will persist until the user has interacted with the alert or the specified timeout has elapsed.

 @since SDL 1.0
 */
@interface SDLAlert : SDLRPCRequest

/**
 * @param alertText1 - alertText1
 * @param alertText2 - alertText2
 * @param alertText3 - alertText3
 * @param ttsChunks - ttsChunks
 * @param duration - duration
 * @param playTone - playTone
 * @param progressIndicator - progressIndicator
 * @param softButtons - softButtons
 * @param alertIcon - alertIcon
 * @param cancelID - cancelID
 * @return A SDLAlert object
 */
- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(nullable NSNumber<SDLUInt> *)duration playTone:(nullable NSNumber<SDLBool> *)playTone progressIndicator:(nullable NSNumber<SDLBool> *)progressIndicator softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons alertIcon:(nullable SDLImage *)alertIcon cancelID:(nullable NSNumber<SDLInt> *)cancelID;

/**
 Convenience init for creating a modal view with text, buttons, and optional sound cues.

 @param alertText The string to be displayed in the first field of the display
 @param softButtons Soft buttons to be displayed
 @param playTone Whether the alert tone should be played before the TTS (if any) is spoken
 @param ttsChunks Speech or a sound file to be played when the alert shows
 @param cancelID An ID for this specific alert to allow cancellation through the `CancelInteraction` RPC
 @param icon Image to be displayed in the alert
 @return An SDLAlert object
 */
- (instancetype)initWithAlertText:(nullable NSString *)alertText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertIcon:(nullable SDLImage *)icon cancelID:(UInt32)cancelID  __deprecated_msg("Use initWithAlertText1:alertText2:alertText3:ttsChunks:duration:playTone:progressIndicator:softButtons:alertIcon:cancelID: instead");

/**
 Convenience init for creating a sound-only alert.

 @param ttsChunks Speech or a sound file to be played when the alert shows
 @param playTone Whether the alert tone should be played before the TTS is spoken
 @return An SDLAlert object
 */
- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone  __deprecated_msg("Use initWithAlertText1:alertText2:alertText3:ttsChunks:duration:playTone:progressIndicator:softButtons:alertIcon:cancelID: instead");

/**
 Convenience init for setting all alert parameters.

 @param alertText1 The first line of the alert
 @param alertText2 The second line of the alert
 @param alertText3 The third line of the alert
 @param softButtons Buttons for the alert
 @param playTone Whether the alert tone should be played before the TTS (if any) is spoken
 @param ttsChunks An array of text chunks to be spoken or a prerecorded sound file
 @param duration The duration of the displayed portion of the alert, in milliseconds
 @param progressIndicator Whether an animation indicating that loading of a feature is progressing should be shown
 @param cancelID An ID for this specific alert to allow cancellation through the `CancelInteraction` RPC
 @param icon Image to be displayed in the alert
 @return An SDLAlert object
 */
- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(UInt16)duration progressIndicator:(BOOL)progressIndicator alertIcon:(nullable SDLImage *)icon cancelID:(UInt32)cancelID  __deprecated_msg("Use initWithAlertText1:alertText2:alertText3:ttsChunks:duration:playTone:progressIndicator:softButtons:alertIcon:cancelID: instead");

/**
 The first line of the alert text field.

 @discussion     At least either `alertText1`, `alertText2` or `ttsChunks` need to be provided.
 @discussion     If supported, the `displayCapabilities` will have a `TextField` with a `name` of `alertText1`.

 String, Optional, Max length 500 chars
 @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSString *alertText1;

/**
 The second line of the alert text field.

 @discussion     At least either `alertText1`, `alertText2` or `ttsChunks` need to be provided.
 @discussion     If supported, the `displayCapabilities` will have a `TextField` with a `name` of `alertText2`

 String, Optional, Max length 500 chars
 @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSString *alertText2;

/**
 The optional third line of the alert text field.

 @discussion If supported, the `displayCapabilities` will have a `TextField` with a `name` of `alertText3`

 String, Optional, Max length 500 chars
 @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSString *alertText3;

/**
 An array of text chunks to be spoken or a prerecorded sound file.

 @discussion At least either `alertText1`, `alertText2` or `ttsChunks` need to be provided.

 Array of SDLTTSChunk, Optional, Array length 1 - 100

 @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *ttsChunks;

/**
 The duration of the displayed portion of the alert, in milliseconds. Typical timeouts are 3 - 5 seconds. If omitted, the timeout is set to a default of 5 seconds.

 Integer, Optional, Min value: 3000, Max value: 10000

 @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *duration;

/**
 Whether the alert tone should be played before the TTS (if any) is spoken. If omitted or set to false, no tone is played.

 Boolean, Optional

 @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *playTone;

/**
 If supported on the given platform, the alert GUI will include some sort of animation indicating that loading of a feature is progressing (e.g. a spinning wheel or hourglass, etc.).

 Boolean, Optional

 @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *progressIndicator;

/**
 Buttons for the displayed alert. If omitted on supported displays, the displayed alert shall not have any buttons.

 Array of SDLSoftButton, Optional, Array size 0 - 4

 @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

/**
 An ID for this specific alert to allow cancellation through the `CancelInteraction` RPC.

 Integer, Optional

 @see SDLCancelInteraction
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

/**
 Image to be displayed in the alert. If omitted on supported displays, no (or the default if applicable) icon should be displayed.

 SDLImage, Optional
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) SDLImage *alertIcon;

@end

NS_ASSUME_NONNULL_END
