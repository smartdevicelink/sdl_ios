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

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"
#import "SDLRPCStruct.h"

/**
 A struct describing a rectangle
 */
@interface SDLRectangle : SDLRPCStruct

/**
 Create a Rectangle

 @param x The top-left x value
 @param y The top-left y value
 @param width The width
 @param height The height
 @return An new SDLRectangle object
 */
- (instancetype)initWithX:(float)x y:(float)y width:(float)width height:(float)height;

/**
 Create a Rectangle from a CGRect

 @param rect The rectangle to use
 @return An new SDLRectangle object
 */
- (instancetype)initWithCGRect:(CGRect)rect;

/**
 *  The X-coordinate of the user control

 *  Required, Float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *x;

/**
 *  The Y-coordinate of the user control

 *  Required, Float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *y;

/**
 *  The width of the user control's bounding rectangle

 *  Required, Float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *width;

/**
 *  The height of the user control's bounding rectangle
 
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *height;

@end
