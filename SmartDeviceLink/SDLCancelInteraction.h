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
 Used to dismiss a modal view programmatically without needing to wait for the timeout to complete. Can be used to dismiss alerts, scrollable messages, sliders, and perform interactions (i.e. pop-up menus).

 @see SDLAlert, SDLScrollableMessage, SDLSlider, SDLPerformInteraction
 */
@interface SDLCancelInteraction : SDLRPCRequest

/**
 Convenience init for dismissing the currently presented modal view (either an alert, slider, scrollable message, or perform interation).

 @param functionID The ID of the type of modal view to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithFunctionID:(UInt32)functionID;

/**
 Convenience init for dismissing a specific view.

 @param functionID The ID of the type of interaction to dismiss
 @param cancelID The ID of the specific interaction to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithFunctionID:(UInt32)functionID cancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing an alert.

 @param cancelID The ID of the specific interaction to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithAlertCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a slider.

 @param cancelID The ID of the specific interaction to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithSliderCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a scrollable message.

 @param cancelID The ID of the specific interaction to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithScrollableMessageCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a perform interaction.

 @param cancelID The ID of the specific interaction to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithPerformInteractionCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a subtle alert.

 @param cancelID The ID of the specific subtle alert to dismiss
 @return A SDLCancelInteraction object
 */
- (instancetype)initWithSubtleAlertCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing the currently presented alert.

 @return A SDLCancelInteraction object
 */
+ (instancetype)alert;

/**
 Convenience init for dismissing the currently presented slider.

 @return A SDLCancelInteraction object
 */
+ (instancetype)slider;

/**
 Convenience init for dismissing the currently presented scrollable message.

 @return A SDLCancelInteraction object
 */
+ (instancetype)scrollableMessage;

/**
 Convenience init for dismissing the currently presented perform interaction.

 @return A SDLCancelInteraction object
 */
+ (instancetype)performInteraction NS_SWIFT_NAME(performInteraction());

/**
 Convenience init for dismissing the currently presented subtle alert.

 @return A SDLCancelInteraction object
 */
+ (instancetype)subtleAlert;

/**
 The ID of the specific interaction to dismiss. If not set, the most recent of the RPC type set in functionID will be dismissed.

 Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

/**
 The ID of the type of interaction to dismiss.

 The ID of the type of interaction the developer wants to dismiss. Only values 10, (PerformInteractionID), 12 (AlertID), 25 (ScrollableMessageID), 26 (SliderID), and 64 (SubtleAlertID) are permitted.

 Integer, Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *functionID;

@end

NS_ASSUME_NONNULL_END
