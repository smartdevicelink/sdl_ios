//
//  SDLTemplateColorScheme.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSNumber+NumberType.h"
#import "SDLRPCStruct.h"

@class SDLRGBColor;

NS_ASSUME_NONNULL_BEGIN

/// A color scheme for all display layout templates.
@interface SDLTemplateColorScheme : SDLRPCStruct

/// Convenience init
///
/// @param primaryColor This must always be your primary brand color
/// @param secondaryColor This may be an accent or complimentary color to your primary brand color
/// @param backgroundColor he background color to be used on the template
/// @return An SDLTemplateColorScheme
- (instancetype)initWithPrimaryRGBColor:(SDLRGBColor *)primaryColor secondaryRGBColor:(SDLRGBColor *)secondaryColor backgroundRGBColor:(SDLRGBColor *)backgroundColor;

///  Convenience init
///
/// @param primaryColor This must always be your primary brand color
/// @param secondaryColor This may be an accent or complimentary color to your primary brand color
/// @param backgroundColor he background color to be used on the template
/// @return An SDLTemplateColorScheme
- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor backgroundColor:(UIColor *)backgroundColor;

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
