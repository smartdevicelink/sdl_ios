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
