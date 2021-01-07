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
#import "SDLButtonPressMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Notifies application of button press events for buttons to which the application is subscribed. SDL supports two button press events defined as follows:

 SHORT - Occurs when a button is depressed, then released within two seconds. The event is considered to occur immediately after the button is released.

 LONG - Occurs when a button is depressed and held for two seconds or more. The event is considered to occur immediately after the two second threshold has been crossed, before the button is released.

 HMI Status Requirements:

 HMILevel:

 The application will receive OnButtonPress notifications for all subscribed buttons when HMILevel is FULL.

 The application will receive OnButtonPress notifications for subscribed media buttons when HMILevel is LIMITED. Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and PRESET_0-PRESET_9.

 The application will not receive OnButtonPress notification when HMILevel is BACKGROUND or NONE.

 AudioStreamingState: Any

 SystemContext: MAIN, VR. In MENU, only PRESET buttons. In VR, pressing any subscribable button will cancel VR.

 @since SDL 1.0
 */
@interface SDLOnButtonPress : SDLRPCNotification

/**
 * @param buttonName - buttonName
 * @param buttonPressMode - buttonPressMode
 * @return A SDLOnButtonPress object
 */
- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode;

/**
 * @param buttonName - buttonName
 * @param buttonPressMode - buttonPressMode
 * @param customButtonID - customButtonID
 * @return A SDLOnButtonPress object
 */
- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode customButtonID:(nullable NSNumber<SDLUInt> *)customButtonID;

/**
 * The button's name
 *
 * Required
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is a LONG or SHORT button press event
 *
 * Required
 */
@property (strong, nonatomic) SDLButtonPressMode buttonPressMode;

/**
 * If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer 0 - 65536
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *customButtonID;

@end

NS_ASSUME_NONNULL_END
