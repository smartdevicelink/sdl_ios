//
//  SDLSpatialStruct.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Defines spatial for each user control object for video streaming application
 */
@interface SDLSpatialStruct : SDLRPCStruct

- (instancetype)initWithId:(UInt32)id x:(float)x y:(float)y width:(float)width height:(float)height;

- (instancetype)initWithId:(NSNumber *)id CGRect:(CGRect)rect;

/**
 *  A user control spatial identifier
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *id;

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

NS_ASSUME_NONNULL_END
