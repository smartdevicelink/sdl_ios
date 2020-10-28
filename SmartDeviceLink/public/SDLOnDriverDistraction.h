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

#import "SDLDriverDistractionState.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Notifies the application of the current driver distraction state (whether driver distraction rules are in effect, or not).

 HMI Status Requirements:

 HMILevel: Can be sent with FULL, LIMITED or BACKGROUND

 AudioStreamingState: Any

 SystemContext: Any

 @since SDL 1.0
 */
@interface SDLOnDriverDistraction : SDLRPCNotification

/**
 * @param state - state
 * @return A SDLOnDriverDistraction object
 */
- (instancetype)initWithState:(SDLDriverDistractionState)state;

/**
 * @param state - state
 * @param lockScreenDismissalEnabled - lockScreenDismissalEnabled
 * @param lockScreenDismissalWarning - lockScreenDismissalWarning
 * @return A SDLOnDriverDistraction object
 */
- (instancetype)initWithState:(SDLDriverDistractionState)state lockScreenDismissalEnabled:(nullable NSNumber<SDLBool> *)lockScreenDismissalEnabled lockScreenDismissalWarning:(nullable NSString *)lockScreenDismissalWarning;

/**
 The driver distraction state (i.e. whether driver distraction rules are in effect, or not)
 */
@property (strong, nonatomic) SDLDriverDistractionState state;

/**
 If enabled, the lock screen will be able to be dismissed while connected to SDL, allowing users the ability to interact with the app.
 
 Optional, Boolean
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *lockScreenDismissalEnabled;

/**
 Warning message to be displayed on the lock screen when dismissal is enabled.  This warning should be used to ensure that the user is not the driver of the vehicle, ex. `Swipe up to dismiss, acknowledging that you are not the driver.`.  This parameter must be present if "lockScreenDismissalEnabled" is set to true.
 
 Optional,  String
 */
@property (strong, nonatomic, nullable) NSString *lockScreenDismissalWarning;

@end

NS_ASSUME_NONNULL_END
