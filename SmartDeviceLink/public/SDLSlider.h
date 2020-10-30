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

NS_ASSUME_NONNULL_BEGIN

/**
 Creates a full screen or pop-up overlay (depending on platform) with a single user controlled slider.

 If connecting to SDL Core v.6.0+, the slider can be canceled programmatically using the `cancelID`. On older versions of SDL Core, the slider will persist until the user has interacted with the slider or the specified timeout has elapsed.

 Since SDL 2.0
 */
@interface SDLSlider : SDLRPCRequest

/**
 * @param numTicks - @(numTicks)
 * @param position - @(position)
 * @param sliderHeader - sliderHeader
 * @return A SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader;

/**
 * @param numTicks - @(numTicks)
 * @param position - @(position)
 * @param sliderHeader - sliderHeader
 * @param sliderFooter - sliderFooter
 * @param timeout - timeout
 * @param cancelID - cancelID
 * @return A SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSArray<NSString *> *)sliderFooter timeout:(nullable NSNumber<SDLUInt> *)timeout cancelID:(nullable NSNumber<SDLInt> *)cancelID;

/**
 Creates a slider with all required data and a static footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooter Text footer to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
+ (instancetype)staticFooterSliderWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(nullable NSNumber<SDLUInt> *)timeout cancelID:(nullable NSNumber<SDLInt> *)cancelID;

/**
 Creates an slider with all required data and a dynamic footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooters Text footers to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
+ (instancetype)dynamicFooterSliderWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(nullable NSNumber<SDLUInt> *)timeout cancelID:(nullable NSNumber<SDLInt> *)cancelID;

/**
 Convenience init with all parameters.

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooters Text footers to display. See the `sliderFooter` documentation for how placing various numbers of footers will affect the display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @param cancelID An ID for this specific slider to allow cancellation through the `CancelInteraction` RPC.
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout cancelID:(UInt32)cancelID __deprecated_msg("Use initWithNumTicks:position:sliderHeader:sliderFooter:timeout:cancelID: instead");

/**
 Creates a slider with only the number of ticks and position. Note that this is not enough to get a SUCCESS response. You must supply additional data. See below for required parameters.

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position __deprecated_msg("Use initWithNumTicks:position:sliderHeader: instead");

/**
 Creates a slider with all required data and a static footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooter Text footer to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout __deprecated_msg("Use staticFooterSliderWithNumTicks:position:sliderHeader:sliderFooter:timeout: instead");

/**
 Creates an slider with all required data and a dynamic footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooters Text footers to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout __deprecated_msg("Use dynamicFooterSliderWithNumTicks:position:sliderHeader:sliderFooters:timeout: instead");

/**
 Represents a number of selectable items on a horizontal axis.

 Integer, Required, Min value: 2, Max Value: 26

 Since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *numTicks;

/**
 Initial position of slider control (cannot exceed numTicks).

 Integer, Required, Min Value: 1, Max Value: 26

 @since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

/**
 Text header to display.

 String, Required, Max length 500 chars

 Since SDL 2.0
 */
@property (strong, nonatomic) NSString *sliderHeader;

/**
 Text footer to display.

 For a static text footer, only one footer string shall be provided in the array.
 For a dynamic text footer, the number of footer text string in the array must match the numTicks value.
 For a dynamic text footer, text array string should correlate with potential slider position index.
 If omitted on supported displays, no footer text shall be displayed.

 Array of Strings, Optional, Array length 1 - 26, Max length 500 chars

 Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *sliderFooter;

/**
 App defined timeout. Indicates how long of a timeout from the last action (i.e. sliding control resets timeout). If omitted, the value is set to 10 seconds.

 Integer, Optional, Min value: 1000, Max value: 65535, Default value: 10000

 Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *timeout;

/**
 An ID for this specific slider to allow cancellation through the `CancelInteraction` RPC.

 Integer, Optional

 @see SDLCancelInteraction
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
