//
//  SDLSpatialStruct.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

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
 *  A user control spatial identifier
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber *id;

/**
 *  The X-coordinate of the user control
 *  Required, Float
 */
@property (strong, nonatomic) NSNumber *x;

/**
 *  The Y-coordinate of the user control
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
