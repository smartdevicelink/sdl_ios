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

#import "SDLRPCMessage.h"

#import "SDLSeatLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about the locations of each seat
 *
 * @added in SmartDeviceLink 6.0.0
 */
@interface SDLSeatLocationCapability : SDLRPCStruct

/**
 * @param rows - rows
 * @param columns - columns
 * @param levels - levels
 * @param seats - seats
 * @return A SDLSeatLocationCapability object
 */
- (instancetype)initWithRows:(nullable NSNumber<SDLUInt> *)rows columns:(nullable NSNumber<SDLUInt> *)columns levels:(nullable NSNumber<SDLUInt> *)levels seats:(nullable NSArray<SDLSeatLocation *> *)seats;

/// Constructs a newly allocated SDLSeatLocationCapability object with all parameters
///
/// @param seats Describes the location of a seat
/// @param cols Number of columns
/// @param rows Number of rows
/// @param levels Number of levels
/// @return An SDLSeatLocationCapability object
- (instancetype)initWithSeats:(NSArray<SDLSeatLocation *> *)seats cols:(NSNumber<SDLInt> *)cols rows:(NSNumber<SDLInt> *)rows levels:(NSNumber<SDLInt> *)levels __deprecated_msg("Use initWithRows:columns:levels:seats: instead");

/**
 * {"num_min_value": 1, "num_max_value": 100}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *columns;

/**
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *cols __deprecated_msg("Use columns instead");

/**
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *rows;

/**
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
