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

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *cols;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *rows;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *levels;

/**
 * Contains a list of SeatLocation in the vehicle, the first element is the driver's seat
 * Optional
 */
@property (strong, nonatomic) SDLSeatLocation *seats;

@end

NS_ASSUME_NONNULL_END
