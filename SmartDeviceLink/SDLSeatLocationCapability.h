//
//  SDLSeatLocationCapability.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

#import "SDLSeatLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about the locations of each seat.
 */
@interface SDLSeatLocationCapability : SDLRPCStruct

/// Constructs a newly allocated SDLSeatLocationCapability object with all parameters
///
/// @param seats Describes the location of a seat
/// @param cols Number of columns
/// @param rows Number of rows
/// @param levels Number of levels
/// @return An SDLSeatLocationCapability object
- (instancetype)initWithSeats:(NSArray<SDLSeatLocation *> *)seats cols:(NSNumber<SDLInt> *)cols rows:(NSNumber<SDLInt> *)rows levels:(NSNumber<SDLInt> *)levels;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *cols;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *rows;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *levels;

/**
 * Contains a list of SeatLocation in the vehicle, the first element is the driver's seat
 * Optional
 */
@property (strong, nonatomic, nullable) NSArray<SDLSeatLocation *> *seats;

@end

NS_ASSUME_NONNULL_END
