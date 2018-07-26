//
//  SDLFuelRange.h
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"
#import "SDLFuelType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes the distance a vehicle can travel with the current level of fuel.
 */
@interface SDLFuelRange : SDLRPCStruct

/**
 *  The vehicle's fuel type
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLFuelType type;

/**
 *  The estimate range in KM the vehicle can travel based on fuel level and consumption.
 *
 *  Optional, Float, 0 - 10,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *range;

@end

NS_ASSUME_NONNULL_END
