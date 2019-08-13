//
//  SDLGrid.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/10/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes a location (origin coordinates and span) of a vehicle component.
 */
@interface SDLGrid : SDLRPCStruct

/**
 *
 * Required, Integer, -1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *col;

/**
 *
 * Required, Integer, -1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *row;

/**
 *
 * Optional, Integer, -1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *level;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *colspan;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *rowspan;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *levelspan;

@end

NS_ASSUME_NONNULL_END
