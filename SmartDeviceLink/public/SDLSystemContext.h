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
 * Indicates whether or not a user-initiated interaction is in progress, and if so, in what mode (i.e. MENU or VR). Used in OnHMIStatus
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSystemContext NS_TYPED_ENUM;

/**
 * No user interaction (user-initiated or app-initiated) is in progress.
 */
extern SDLSystemContext const SDLSystemContextMain;

/**
 * VR-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextVoiceRecognitionSession;

/**
 * Menu-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextMenu;

/**
 * The app's display HMI is currently being obscured by either a system or other app's overlay.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextHMIObscured;

/**
 * Broadcast only to whichever app has an alert currently being displayed.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextAlert;
