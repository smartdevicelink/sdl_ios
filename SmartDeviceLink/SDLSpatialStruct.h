//
//  SDLSpatialStruct.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

/**
 *  Defines spatial for each user control object for video streaming application
 */
@interface SDLSpatialStruct : SDLRPCStruct

/**
 *  @abstract Constructs a newly allocated SDLSpatialStruct object
 */
- (instancetype)init;

/**
 *  @abstract Constructs a newly allocated SDLSpatialStruct object indicated by the dictionary parameter
 *  @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 Create a SpatialStruct

 @param id The id of the rectangle
 @param x The top-left x value
 @param y The top-left y value
 @param width The width
 @param height The height
 @return An new SDLSpatialStruct object
 */
- (instancetype)initWithId:(NSNumber *)id xCoord:(NSNumber *)x yCoord:(NSNumber *)y width:(NSNumber *)width height:(NSNumber *)height;

/**
 Create a SpatialStruct from a CGRect

 @param id The id of the rectangle
 @param rect The rectangle to use
 @return An new SDLSpatialStruct object
 */
- (instancetype)initWithId:(NSNumber *)id CGRect:(CGRect)rect;

/**
 *  A user control spatial identifier
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber *id;

/**
 *  The X-coordinate of the top-left corner of the user control
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *x;

/**
 *  The Y-coordinate of the top-left corner of the user control
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *y;

/**
 *  The width of the user control's bounding rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *width;

/**
 *  The height of the user control's bounding rectangle
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *height;

@end
