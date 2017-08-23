//
//  SDLRectangle.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/23/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

@interface SDLRectangle : SDLRPCStruct

/**
 *  @abstract Constructs a newly allocated SDLRectangle object
 */
- (instancetype)init;

/**
 *  @abstract Constructs a newly allocated SDLRectangle object indicated by the dictionary parameter
 *  @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 Create a Rectangle

 @param x The top-left x value
 @param y The top-left y value
 @param width The width
 @param height The height
 @return An new SDLRectangle object
 */
- (instancetype)initWithX:(NSNumber *)x y:(NSNumber *)y width:(NSNumber *)width height:(NSNumber *)height;

/**
 Create a Rectangle from a CGRect

 @param rect The rectangle to use
 @return An new SDLRectangle object
 */
- (instancetype)initWithCGRect:(CGRect)rect;

/**
 *  The upper left X-coordinate of the rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *x;

/**
 *  The upper left Y-coordinate of the rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *y;

/**
 *  The width of the rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *width;

/**
 *  The height of the rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *height;


@end
