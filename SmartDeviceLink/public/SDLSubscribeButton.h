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

#import "SDLButtonName.h"
#import "SDLNotificationConstants.h"
#import "SDLRPCRequest.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Establishes a subscription to button notifications for HMI buttons. Buttons
 * are not necessarily physical buttons, but can also be "soft" buttons on a
 * touch screen, depending on the display in the vehicle. Once subscribed to a
 * particular button, an application will receive both
 * SDLOnButtonEvent and SDLOnButtonPress notifications
 * whenever that button is pressed. The application may also unsubscribe from
 * notifications for a button by invoking the SDLUnsubscribeButton
 * operation
 * <p>
 * When a button is depressed, an SDLOnButtonEvent notification is
 * sent to the application with a ButtonEventMode of BUTTONDOWN. When that same
 * button is released, an SDLOnButtonEvent notification is sent to the
 * application with a ButtonEventMode of BUTTONUP
 * <p>
 * When the duration of a button depression (that is, time between depression
 * and release) is less than two seconds, an SDLOnButtonPress
 * notification is sent to the application (at the moment the button is
 * released) with a ButtonPressMode of SHORT. When the duration is two or more
 * seconds, an SDLOnButtonPress notification is sent to the
 * application (at the moment the two seconds have elapsed) with a
 * ButtonPressMode of LONG
 * <p>
 * The purpose of SDLOnButtonPress notifications is to allow for
 * programmatic detection of long button presses similar to those used to store
 * presets while listening to the radio, for example
 * <p>
 * When a button is depressed and released, the sequence in which notifications
 * will be sent to the application is as follows:
 * <p>
 * For short presses:<br/>
 * <ul>
 * <li>OnButtonEvent (ButtonEventMode = BUTTONDOWN)</li>
 * <li>OnButtonEvent (ButtonEventMode = BUTTONUP)</li>
 * <li>OnButtonPress (ButtonPressMode = SHORT)</li>
 * </ul>
 * <p>
 * For long presses:<br/>
 * <ul>
 * <li>OnButtonEvent (ButtonEventMode = BUTTONDOWN)</li>
 * <li>OnButtonEvent (ButtonEventMode = BUTTONUP)</li>
 * <li>OnButtonPress (ButtonPressMode = LONG)</li>
 * </ul>
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0<br/>
 * See SDLUnsubscribeButton
 */
@interface SDLSubscribeButton : SDLRPCRequest

/**
 * @param buttonName - buttonName
 * @return A SDLSubscribeButton object
 */
- (instancetype)initWithButtonName:(SDLButtonName)buttonName;

/**
 *  Construct a SDLSubscribeButton with a handler callback when an event occurs.
 *
 *  @param handler A callback that will be called when a button event occurs for the subscribed button.
 *
 *  @return An SDLSubscribeButton object
 */
- (instancetype)initWithHandler:(nullable SDLRPCButtonNotificationHandler)handler __deprecated_msg("Use initWithButtonName: instead");

/// Construct a SDLSubscribeButton with a handler callback when an event occurs with a button name.
///
/// @param buttonName The name of the button to subscribe to
/// @param handler A callback that will be called when a button event occurs for the subscribed button
/// @return An SDLSubscribeButton object
- (instancetype)initWithButtonName:(SDLButtonName)buttonName handler:(nullable SDLRPCButtonNotificationHandler)handler __deprecated_msg("Use initWithButtonName: instead");

/**
 *  A handler that will let you know when the button you subscribed to is selected.
 *
 *  @warning This will only work if you use SDLManager.
 */
@property (copy, nonatomic) SDLRPCButtonNotificationHandler handler;

/**
 * The name of the button to subscribe to
 * @discussion An enum value, see <i>SDLButtonName</i>
 */
@property (strong, nonatomic) SDLButtonName buttonName;

@end

NS_ASSUME_NONNULL_END
