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
 The name that identifies the field. Used in DisplayCapabilities.

 @since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLImageFieldName NS_TYPED_ENUM;

/**
 The image field for Alert
 */
extern SDLImageFieldName const SDLImageFieldNameAlertIcon;

/**
 The image field for SoftButton
 */
extern SDLImageFieldName const SDLImageFieldNameSoftButtonImage;

/**
 The first image field for Choice.
 */
extern SDLImageFieldName const SDLImageFieldNameChoiceImage;

/**
 The scondary image field for Choice.
 */
extern SDLImageFieldName const SDLImageFieldNameChoiceSecondaryImage;

/**
 The image field for vrHelpItem.
 */
extern SDLImageFieldName const SDLImageFieldNameVoiceRecognitionHelpItem;

/**
 The image field for Turn.
 */
extern SDLImageFieldName const SDLImageFieldNameTurnIcon;

/**
 The image field for the menu icon in SetGlobalProperties.
 */
extern SDLImageFieldName const SDLImageFieldNameMenuIcon;

/** The image field for AddCommand.
 *
 */
extern SDLImageFieldName const SDLImageFieldNameCommandIcon;

/**
 The image field for the app icon (set by setAppIcon).
 */
extern SDLImageFieldName const SDLImageFieldNameAppIcon;

/** The primary image field for Show.
 *
 */
extern SDLImageFieldName const SDLImageFieldNameGraphic;

/** The secondary image field for Show.
 *
 */
extern SDLImageFieldName const SDLImageFieldNameSecondaryGraphic;

/** The primary image field for ShowConstant TBT.
 *
 */
extern SDLImageFieldName const SDLImageFieldNameShowConstantTBTIcon;

/**
 The secondary image field for ShowConstant TBT.
 */
extern SDLImageFieldName const SDLImageFieldNameShowConstantTBTNextTurnIcon;

/**
 The optional image of a destination / location

 @since SDL 4.0
 */
extern SDLImageFieldName const SDLImageFieldNameLocationImage;

/**
 * The image field for AddSubMenu.menuIcon
 *
 * @since SDL 7.0
 */
extern SDLImageFieldName const SDLImageFieldNameSubMenuIcon;

/**
 * The image of the subtle alert; applies to `SubtleAlert` `alertImage`
 *
 * @since SDL 7.0
 */
extern SDLImageFieldName const SDLImageFieldNameSubtleAlertIcon;
