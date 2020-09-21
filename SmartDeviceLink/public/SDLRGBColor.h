//
//  SDLRGBColor.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/18/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSNumber+NumberType.h"
#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents an RGB color
///
/// @since 5.0
@interface SDLRGBColor : SDLRPCStruct

/**
 Create an SDL color object with red / green / blue values between 0-255

 @param red The red value of the color
 @param green The green value of the color
 @param blue The blue value of the color
 @return The color
 */
- (instancetype)initWithRed:(UInt8)red green:(UInt8)green blue:(UInt8)blue;

/**
 Create an SDL color object with a UIColor object.

 @warning The alpha color of the UIColor object will be ignored

 @param color The UIColor object to base this color on
 @return The color
 */
- (instancetype)initWithColor:(UIColor *)color;

/**
 *  The red value of the RGB color
 *  Required, Integer, 0-255
 */
@property (copy, nonatomic) NSNumber<SDLInt> *red;

/**
 *  The green value of the RGB color
 *  Required, Integer, 0-255
 */
@property (copy, nonatomic) NSNumber<SDLInt> *green;

/**
 *  The blue value of the RGB color
 *  Required, Integer, 0-255
 */
@property (copy, nonatomic) NSNumber<SDLInt> *blue;

@end

NS_ASSUME_NONNULL_END
