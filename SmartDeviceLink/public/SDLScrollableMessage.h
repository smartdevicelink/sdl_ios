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

NS_ASSUME_NONNULL_BEGIN

/**
 Creates a full screen overlay containing a large block of formatted text that can be scrolled with buttons available.

 If connecting to SDL Core v.6.0+, the scrollable message can be canceled programmatically using the `cancelID`. On older versions of SDL Core, the scrollable message will persist until the user has interacted with the scrollable message or the specified timeout has elapsed.

 @since SDL 2.0
 */
@interface SDLScrollableMessage : SDLRPCRequest

/**
 Convenience init for creating a scrolling message with text.

 @param message Body of text that can include newlines and tabs
 @return A SDLScrollableMessage object
 */
- (instancetype)initWithMessage:(NSString *)message;

/**
 Convenience init for creating a scrolling message with text and buttons.

 @param message Body of text that can include newlines and tabs
 @param timeout Indicates how long of a timeout from the last action (i.e. scrolling message resets timeout)
 @param softButtons Buttons for the displayed scrollable message
 @param cancelID An ID for this specific scrollable message to allow cancellation through the `CancelInteraction` RPC
 @return A SDLScrollableMessage object
 */
- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(UInt32)cancelID;

/**
 Body of text that can include newlines and tabs.

 String, Required, Max length 500 chars

 @since SDL 2.0
 */
@property (strong, nonatomic) NSString *scrollableMessageBody;

/**
 App defined timeout. Indicates how long of a timeout from the last action (i.e. scrolling message resets timeout). If not set, a default value of 30 seconds is used by Core.

 Integer, Optional, Min value: 1000, Max value: 65535, Default value: 30000

 @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;

/**
 Buttons for the displayed scrollable message. If omitted on supported displays, only the system defined "Close" SoftButton will be displayed.

 Array of SDLSoftButton, Optional, Array size: 0-8

 Since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

/**
 An ID for this specific scrollable message to allow cancellation through the `CancelInteraction` RPC.

 Integer, Optional

 @see SDLCancelInteraction
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
