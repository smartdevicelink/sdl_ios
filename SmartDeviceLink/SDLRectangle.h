//
//  SDLRectangle.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/23/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

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
