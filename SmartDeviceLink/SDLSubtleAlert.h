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
 * Shows an alert which typically consists of text-to-speech message and text on the display. At least either alertText1, alertText2 or TTSChunks need to be provided.
 *
 * @since SDL 7.0.0
 */
@interface SDLSubtleAlert : SDLRPCRequest

/**
 * @param alertText1 - alertText1
 * @param alertText2 - alertText2
 * @param alertIcon - alertIcon
 * @param ttsChunks - ttsChunks
 * @param duration - duration
 * @param softButtons - softButtons
 * @param cancelID - cancelID
 * @return A SDLSubtleAlert object
 */
- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertIcon:(nullable SDLImage *)alertIcon ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(nullable NSNumber<SDLUInt> *)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(nullable NSNumber<SDLInt> *)cancelID;

/**
 * The first line of the alert text field
 * {"default_value": null, "max_length": 500, "min_length": 1}
 */
@property (nullable, strong, nonatomic) NSString *alertText1;

/**
 * The second line of the alert text field
 * {"default_value": null, "max_length": 500, "min_length": 1}
 */
@property (nullable, strong, nonatomic) NSString *alertText2;

/**
 * Image to be displayed for the corresponding alert. See Image. If omitted on supported displays, no (or the default if applicable) icon should be displayed.
 */
@property (nullable, strong, nonatomic) SDLImage *alertIcon;

/**
 * An array of text chunks of type TTSChunk. See TTSChunk. The array must have at least one item.
 * {"default_value": null, "max_size": 100, "min_size": 1}
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *ttsChunks;

/**
 * Timeout in milliseconds. Typical timeouts are 3-5 seconds. If omitted, timeout is set to 5s.
 * {"default_value": 5000, "max_value": 10000, "min_value": 3000}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *duration;

/**
 * App defined SoftButtons. If omitted on supported displays, the displayed alert shall not have any SoftButtons.
 * {"default_value": null, "max_size": 2, "min_size": 0}
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

/**
 * An ID for this specific alert to allow cancellation through the `CancelInteraction` RPC.
 * {"default_value": null, "max_value": null, "min_value": null}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
