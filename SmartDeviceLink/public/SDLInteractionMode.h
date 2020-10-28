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
 For application-initiated interactions (SDLPerformInteraction), this specifies the mode by which the user is prompted and by which the user's selection is indicated. Used in PerformInteraction.

 @since SDL 1.0
 */
typedef SDLEnum SDLInteractionMode NS_TYPED_ENUM;

/**
 Interaction Mode : Manual Only

 This mode causes the interaction to occur only on the display, meaning the choices are presented and selected only via the display. Selections are viewed with the SEEKRIGHT, SEEKLEFT, TUNEUP, TUNEDOWN buttons. User's selection is indicated with the OK button
 */
extern SDLInteractionMode const SDLInteractionModeManualOnly;

/**
 Interaction Mode : VR Only

 This mode causes the interaction to occur only through TTS and VR. The user is prompted via TTS to select a choice by saying one of the choice's synonyms
 */
extern SDLInteractionMode const SDLInteractionModeVoiceRecognitionOnly;

/**
 Interaction Mode : Manual & VR

 @discussion This mode is a combination of MANUAL_ONLY and VR_ONLY, meaning the user is prompted both visually and audibly. The user can make a selection either using the mode described in MANUAL_ONLY or using the mode described in VR_ONLY.

 If the user views selections as described in MANUAL_ONLY mode, the interaction becomes strictly, and irreversibly, a MANUAL_ONLY interaction (i.e. the VR session is cancelled, although the interaction itself is still in progress). If the user interacts with the VR session in any way (e.g. speaks a phrase, even if it is not a recognized choice), the interaction becomes strictly, and irreversibly, a VR_ONLY interaction (i.e. the MANUAL_ONLY mode forms of interaction will no longer be honored)

 The TriggerSource parameter of the *PerformInteraction* response will indicate which interaction mode the user finally chose to attempt the selection (even if the interaction did not end with a selection being made)
 */
extern SDLInteractionMode const SDLInteractionModeBoth;
