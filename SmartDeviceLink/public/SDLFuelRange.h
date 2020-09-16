//
//  SDLFuelRange.h
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLCapacityUnit.h"
#import "SDLComponentVolumeStatus.h"
#import "SDLRPCMessage.h"
#import "SDLFuelType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes the distance a vehicle can travel with the current level of fuel.
 */
@interface SDLFuelRange : SDLRPCStruct

/**
 *  @param  type - type
 *  @param  range - @(range)
 *  @param  level - @(level)
 *  @param  levelState - levelState
 *  @param  capacity - @(capacity)
 *  @param  capacityUnit - capacityUnit
 *  @return A SDLFuelRange object
 */
- (instancetype)initWithType:(nullable SDLFuelType)type range:(float)range level:(float)level levelState:(nullable SDLComponentVolumeStatus)levelState capacity:(float)capacity capacityUnit:(nullable SDLCapacityUnit)capacityUnit;

/**
 * The absolute capacity of this fuel type.
 *
 * Optional, Float, 0.0 - 1000000.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *capacity;

/**
 * The unit of the capacity of this fuel type such as liters for gasoline or kWh for batteries.
 */
@property (strong, nonatomic, nullable) SDLCapacityUnit capacityUnit;

/**
 * The relative remaining capacity of this fuel type (percentage).
 *
 * Optional, Float, -6.0 - 1000000.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *level;

/**
 * The fuel level state.
 */
@property (strong, nonatomic, nullable) SDLComponentVolumeStatus levelState;

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
