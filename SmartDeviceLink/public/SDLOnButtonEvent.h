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

#import "SDLButtonName.h"
#import "SDLButtonEventMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Notifies application that user has depressed or released a button to which
 the application has subscribed.

 Further information about button events and button-presses can be found at SDLSubscribeButton.

 HMI Status Requirements:

 HMILevel:

 * The application will receive <i>SDLOnButtonEvent</i> notifications for all subscribed buttons when HMILevel is FULL.

 * The application will receive <i>SDLOnButtonEvent</i> notifications for subscribed media buttons when HMILevel is LIMITED.

 * Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and PRESET_0-PRESET_9.

 * The application will not receive <i>SDLOnButtonEvent</i> notification when HMILevel is BACKGROUND.
 
 AudioStreamingState:
   * Any

 SystemContext:

 * MAIN, VR. In MENU, only PRESET buttons.

 * In VR, pressing any subscribable button will cancel VR.

 @see SDLSubscribeButton

 @since SDL 1.0
 */
@interface SDLOnButtonEvent : SDLRPCNotification

/**
 * @param buttonName - buttonName
 * @param buttonEventMode - buttonEventMode
 * @return A SDLOnButtonEvent object
 */
- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonEventMode:(SDLButtonEventMode)buttonEventMode;

/**
 * @param buttonName - buttonName
 * @param buttonEventMode - buttonEventMode
 * @param customButtonID - customButtonID
 * @return A SDLOnButtonEvent object
 */
- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonEventMode:(SDLButtonEventMode)buttonEventMode customButtonID:(nullable NSNumber<SDLUInt> *)customButtonID;

/**
 * The name of the button
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is an UP or DOWN event
 */
@property (strong, nonatomic) SDLButtonEventMode buttonEventMode;

/**
 * If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer, 0 - 65536
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *customButtonID;

@end

NS_ASSUME_NONNULL_END
