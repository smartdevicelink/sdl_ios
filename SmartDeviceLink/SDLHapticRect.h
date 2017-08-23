//
//  SDLHapticRect.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

@class SDLRectangle;

/**
 *  Defines spatial for each user control object for video streaming application
 */
@interface SDLHapticRect : SDLRPCStruct

/**
 *  @abstract Constructs a newly allocated SDLHapticRect object
 */
- (instancetype)init;

/**
 *  @abstract Constructs a newly allocated SDLHapticRect object indicated by the dictionary parameter
 *  @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 Create a SpatialStruct

 @param id The id of the rectangle
 @param rect The SDLRectangle to use as the bounding rectangle
 @return An new SDLHapticRect object
 */
- (instancetype)initWithId:(NSNumber *)id rect:(SDLRectangle *)rect;

/**
 *  A user control spatial identifier
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber *id;

/**
 The position of the haptic rectangle to be highlighted. The center of this rectangle will be "touched" when a press occurs.

 Required
 */
@property (strong, nonatomic) SDLRectangle *rect;

@end
