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

#import "SDLNotificationConstants.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

/**
 Describes an on-screen button which may be presented in various contexts, e.g. templates or alerts

 @added in SmartDeviceLink 2.0.0
 */
@interface SDLSoftButton : SDLRPCStruct

/**
 * @param type - type
 * @param softButtonID - @(softButtonID)
 * @return A SDLSoftButton object
 */
- (instancetype)initWithType:(SDLSoftButtonType)type softButtonID:(UInt16)softButtonID;

/**
 * @param type - type
 * @param softButtonID - @(softButtonID)
 * @param text - text
 * @param image - image
 * @param isHighlighted - isHighlighted
 * @param systemAction - systemAction
 * @return A SDLSoftButton object
 */
- (instancetype)initWithType:(SDLSoftButtonType)type softButtonID:(UInt16)softButtonID text:(nullable NSString *)text image:(nullable SDLImage *)image isHighlighted:(nullable NSNumber<SDLBool> *)isHighlighted systemAction:(nullable SDLSystemAction)systemAction;

/// Convenience init
///
/// @param handler A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur
- (instancetype)initWithHandler:(nullable SDLRPCButtonNotificationHandler)handler __deprecated_msg("Use initWithType:softButtonID: instead");

/// Convenience init
///
/// @param type Describes whether this soft button displays only text, only an image, or both
/// @param text Optional text to display (if defined as TEXT or BOTH type)
/// @param image Optional image struct for SoftButton (if defined as IMAGE or BOTH type)
/// @param highlighted Displays in an alternate mode, e.g. with a colored background or foreground. Depends on the IVI system
/// @param buttonId Value which is returned via OnButtonPress / OnButtonEvent
/// @param systemAction Parameter indicating whether selecting a SoftButton shall call a specific system action
/// @param handler A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur.
- (instancetype)initWithType:(SDLSoftButtonType)type text:(nullable NSString *)text image:(nullable SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(nullable SDLSystemAction)systemAction handler:(nullable SDLRPCButtonNotificationHandler)handler __deprecated_msg("Use initWithType:softButtonID: instead");

/// A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur.
@property (copy, nonatomic) SDLRPCButtonNotificationHandler handler;

/**
 Describes whether this soft button displays only text, only an image, or both

 Required
 */
@property (strong, nonatomic) SDLSoftButtonType type;

/**
 Optional text to display (if defined as TEXT or BOTH type)

 Optional
 */
@property (strong, nonatomic, nullable) NSString *text;

/**
 Optional image struct for SoftButton (if defined as IMAGE or BOTH type)

 Optional
 */
@property (strong, nonatomic, nullable) SDLImage *image;

/**
 Displays in an alternate mode, e.g. with a colored background or foreground. Depends on the IVI system.

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *isHighlighted;

/**
 Value which is returned via OnButtonPress / OnButtonEvent

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *softButtonID;

/**
 Parameter indicating whether selecting a SoftButton shall call a specific system action. This is intended to allow Notifications to bring the callee into full / focus; or in the case of persistent overlays, the overlay can persist when a SoftButton is pressed.

 Optional
 */
@property (strong, nonatomic, nullable) SDLSystemAction systemAction;

@end

NS_ASSUME_NONNULL_END
