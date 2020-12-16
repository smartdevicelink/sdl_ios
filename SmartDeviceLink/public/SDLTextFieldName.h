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
 * @added in SmartDeviceLink 1.0.0
 */
typedef SDLEnum SDLTextFieldName NS_TYPED_ENUM;

/**
 * The first line of first set of main fields of the persistent display; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMainField1;

/**
 * The second line of first set of main fields of the persistent display; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMainField2;

/**
 * The first line of second set of main fields of persistent display; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMainField3;

/**
 * The second line of second set of main fields of the persistent display; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMainField4;

/**
 * The status bar on NGN; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameStatusBar;

/**
 * Text value for MediaClock field; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMediaClock;

/**
 * The track field of NGN and GEN1.1 MFD displays. This field is only available for media applications; applies to "Show"
 */
extern SDLTextFieldName const SDLTextFieldNameMediaTrack;

/**
 * The title of the new template that will be displayed; applies to "Show"
 *
 * @added in SmartDeviceLink 6.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameTemplateTitle;

/**
 * The first line of the alert text field; applies to "Alert"
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText1;

/**
 * The second line of the alert text field; applies to "Alert"
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText2;

/**
 * The third line of the alert text field; applies to "Alert"
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText3;

/**
 * Long form body of text that can include newlines and tabs; applies to "ScrollableMessage"
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameScrollableMessageBody;

/**
 * First line suggestion for a user response (in the case of VR enabled interaction)
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameInitialInteractionText;

/**
 * First line of navigation text
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameNavigationText1;

/**
 * Second line of navigation text
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameNavigationText2;

/**
 * Estimated Time of Arrival time for navigation
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameEta;

/**
 * Total distance to destination for navigation
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameTotalDistance;

/**
 * First line of text for audio pass thru
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameAudioPassThruDisplayText1;

/**
 * Second line of text for audio pass thru
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameAudioPassThruDisplayText2;

/**
 * Header text for slider
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameSliderHeader;

/**
 * Footer text for slider
 *
 * @added in SmartDeviceLink 2.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameSliderFooter;

/**
 * Primary text for Choice
 */
extern SDLTextFieldName const SDLTextFieldNameMenuName;

/**
 * Secondary text for Choice
 */
extern SDLTextFieldName const SDLTextFieldNameSecondaryText;

/**
 * Tertiary text for Choice
 */
extern SDLTextFieldName const SDLTextFieldNameTertiaryText;

/**
 * Optional text to label an app menu button (for certain touchscreen platforms).
 */
extern SDLTextFieldName const SDLTextFieldNameMenuTitle;

/**
 * Optional name / title of intended location for SendLocation.
 *
 * @added in SmartDeviceLink 4.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameLocationName;

/**
 * Optional description of intended location / establishment (if applicable) for SendLocation.
 *
 * @added in SmartDeviceLink 4.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameLocationDescription;

/**
 * Optional location address (if applicable) for SendLocation.
 *
 * @added in SmartDeviceLink 4.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameAddressLines;

/**
 * Optional phone number of intended location / establishment (if applicable) for SendLocation.
 *
 * @added in SmartDeviceLink 4.0.0
 */
extern SDLTextFieldName const SDLTextFieldNamePhoneNumber;

/**
 * Optional time to destination field for navigationTexts parameter in ShowConstantTB
 *
 * @added in SmartDeviceLink 7.1.0
 */
extern SDLTextFieldName const SDLTextFieldNameTimeToDestination;

/**
 * Turn text for turnList parameter of UpdateTurnList
 *
 * @added in SmartDeviceLink 7.1.0
 */
extern SDLTextFieldName const SDLTextFieldNameTurnText;

/**
 * Navigation text for turnList parameter of UpdateTurnList
 *
 * @added in SmartDeviceLink 7.1.0
 */
extern SDLTextFieldName const SDLTextFieldNameNavigationText;

/**
 * The first line of the subtle alert text field; applies to `SubtleAlert` `alertText1`
 *
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameSubtleAlertText1;

/**
 * The second line of the subtle alert text field; applies to `SubtleAlert` `alertText2`
 *
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameSubtleAlertText2;

/**
 * A text field in the soft button of a subtle alert; applies to `SubtleAlert` `softButtons`
 *
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLTextFieldName const SDLTextFieldNameSubtleAlertSoftButtonText;
