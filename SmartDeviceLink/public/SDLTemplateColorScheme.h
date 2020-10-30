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

#import <UIKit/UIKit.h>

#import "NSNumber+NumberType.h"
#import "SDLRPCStruct.h"

@class SDLRGBColor;

NS_ASSUME_NONNULL_BEGIN

/**
 * A color scheme for all display layout templates.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@interface SDLTemplateColorScheme : SDLRPCStruct

/**
 * @param primaryColor - primaryColor
 * @param secondaryColor - secondaryColor
 * @param backgroundColor - backgroundColor
 * @return A SDLTemplateColorScheme object
 */
- (instancetype)initWithPrimaryColorParam:(nullable SDLRGBColor *)primaryColor secondaryColor:(nullable SDLRGBColor *)secondaryColor backgroundColor:(nullable SDLRGBColor *)backgroundColor __deprecated_msg("Eventually an initializer without param will be added");

///  Convenience init
///
/// @param primaryColor This must always be your primary brand color
/// @param secondaryColor This may be an accent or complimentary color to your primary brand color
/// @param backgroundColor he background color to be used on the template
/// @return An SDLTemplateColorScheme
+ (instancetype)schemeWithPrimaryUIColor:(UIColor *)primaryColor secondaryUIColor:(UIColor *)secondaryColor backgroundUIColor:(UIColor *)backgroundColor;

/// Convenience init
///
/// @param primaryColor This must always be your primary brand color
/// @param secondaryColor This may be an accent or complimentary color to your primary brand color
/// @param backgroundColor he background color to be used on the template
/// @return An SDLTemplateColorScheme
- (instancetype)initWithPrimaryRGBColor:(SDLRGBColor *)primaryColor secondaryRGBColor:(SDLRGBColor *)secondaryColor backgroundRGBColor:(SDLRGBColor *)backgroundColor __deprecated;

///  Convenience init
///
/// @param primaryColor This must always be your primary brand color
/// @param secondaryColor This may be an accent or complimentary color to your primary brand color
/// @param backgroundColor he background color to be used on the template
/// @return An SDLTemplateColorScheme
- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor backgroundColor:(UIColor *)backgroundColor __deprecated_msg("Use schemeWithPrimaryUIColor:secondaryUIColor:backgroundUIColor: instead");

/**
 The "primary" color. This must always be your primary brand color. If the OEM only uses one color, this will be the color. It is recommended to the OEMs that the primaryColor should change the `mediaClockTimer` bar and the highlight color of soft buttons.
 */
@property (strong, nonatomic, nullable) SDLRGBColor *primaryColor;

/**
 The "secondary" color. This may be an accent or complimentary color to your primary brand color. If the OEM uses this color, they must also use the primary color. It is recommended to the OEMs that the secondaryColor should change the background color of buttons, such as soft buttons.
 */
@property (strong, nonatomic, nullable) SDLRGBColor *secondaryColor;

/**
 The background color to be used on the template. If the OEM does not support this parameter, assume on "dayColorScheme" that this will be a light color, and on "nightColorScheme" a dark color. You should do the same for your custom schemes.
 */
@property (strong, nonatomic, nullable) SDLRGBColor *backgroundColor;

@end

NS_ASSUME_NONNULL_END
