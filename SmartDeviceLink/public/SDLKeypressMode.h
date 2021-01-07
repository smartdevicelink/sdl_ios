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

#import "SDLEnum.h"

/**
 Enumeration listing possible keyboard events.

 Note: Depending on keypressMode value (from keyboardProperties structure of UI.SetGlobalProperties), HMI must send the onKeyboardInput notification with the following data:

 SINGLE_KEYPRESS,QUEUE_KEYPRESSES,RESEND_CURRENT_ENTRY.

 @since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLKeypressMode NS_TYPED_ENUM;

/**
 SINGLE_KEYPRESS:<br>Each and every User`s keypress must be reported (new notification for every newly entered single symbol).
 */
extern SDLKeypressMode const SDLKeypressModeSingleKeypress;

/**
 QUEUE_KEYPRESSES:<br>The whole entry is reported only after the User submits it (by ‘Search’ button click displayed on touchscreen keyboard)
 */
extern SDLKeypressMode const SDLKeypressModeQueueKeypresses;

/**
 RESEND_CURRENT_ENTRY:<br>The whole entry must be reported each and every time the User makes a new keypress<br> (new notification with all previously entered symbols and a newly entered one appended).
 */
extern SDLKeypressMode const SDLKeypressModeResendCurrentEntry;
