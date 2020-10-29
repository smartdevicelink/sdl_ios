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
 A template layout an app uses to display information. The broad details of the layout are defined, but the details depend on the IVI system. Used in SetDisplayLayout.
 */
typedef SDLEnum SDLPredefinedLayout NS_TYPED_ENUM;

/**
 A default layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutDefault;

/**
 The default media layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutMedia;

/**
 The default non-media layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNonMedia;

/**
 A media layout containing preset buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutOnscreenPresets;

/**
 The default navigation layout with a fullscreen map
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationFullscreenMap;

/**
 A list layout used for navigation apps
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationList;

/**
 A keyboard layout used for navigation apps
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationKeyboard;

/**
 A layout with a single graphic on the left and text on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithText;

/**
 A layout with text on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextWithGraphic;

/**
 A layout with only softbuttons placed in a tile layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTilesOnly;

/**
 A layout with only soft buttons that only accept text
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextButtonsOnly;

/**
 A layout with a single graphic on the left and soft buttons in a tile layout on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTiles;

/**
 A layout with soft buttons in a tile layout on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTilesWithGraphic;

/**
 A layout with a single graphic on the left and both text and soft buttons on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTextAndSoftButtons;

/**
 A layout with both text and soft buttons on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextAndSoftButtonsWithGraphic;

/**
 A layout with a single graphic on the left and text-only soft buttons on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTextButtons;

/**
 A layout with text-only soft buttons on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextButtonsWithGraphic;

/**
 A layout with a single large graphic and soft buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutLargeGraphicWithSoftButtons;

/**
 A layout with two graphics and soft buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutDoubleGraphicWithSoftButtons;

/**
 A layout with only a single large graphic
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutLargeGraphicOnly;


/**
 Custom root template allowing in-vehicle WebEngine applications with
 appropriate permissions to show the application's own web view.

 @since 7.0
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutWebView;
