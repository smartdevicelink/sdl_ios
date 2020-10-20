/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

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
 * @param type - type
 * @param range - range
 * @param level - level
 * @param levelState - levelState
 * @param capacity - capacity
 * @param capacityUnit - capacityUnit
 * @return A SDLFuelRange object
 */
- (instancetype)initWithTypeParam:(nullable SDLFuelType)type range:(nullable NSNumber<SDLFloat> *)range level:(nullable NSNumber<SDLFloat> *)level levelState:(nullable SDLComponentVolumeStatus)levelState capacity:(nullable NSNumber<SDLFloat> *)capacity capacityUnit:(nullable SDLCapacityUnit)capacityUnit __deprecated;

/**
 *  @param  type - type
 *  @param  range - @(range)
 *  @param  level - @(level)
 *  @param  levelState - levelState
 *  @param  capacity - @(capacity)
 *  @param  capacityUnit - capacityUnit
 *  @return A SDLFuelRange object
 */
- (instancetype)initWithType:(nullable SDLFuelType)type range:(float)range level:(float)level levelState:(nullable SDLComponentVolumeStatus)levelState capacity:(float)capacity capacityUnit:(nullable SDLCapacityUnit)capacityUnit __deprecated;

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
