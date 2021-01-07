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

#import "SDLCompassDirection.h"
#import "SDLDimension.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the GPS data. Not all data will be available on all carlines.
 *
 * @since SDL 2.0
 */
@interface SDLGPSData : SDLRPCStruct

/**
 * @param longitudeDegrees - @(longitudeDegrees)
 * @param latitudeDegrees - @(latitudeDegrees)
 * @return A SDLGPSData object
 */
- (instancetype)initWithLongitudeDegrees:(float)longitudeDegrees latitudeDegrees:(float)latitudeDegrees;

/**
 * @param longitudeDegrees - @(longitudeDegrees)
 * @param latitudeDegrees - @(latitudeDegrees)
 * @param utcYear - utcYear
 * @param utcMonth - utcMonth
 * @param utcDay - utcDay
 * @param utcHours - utcHours
 * @param utcMinutes - utcMinutes
 * @param utcSeconds - utcSeconds
 * @param compassDirection - compassDirection
 * @param pdop - pdop
 * @param hdop - hdop
 * @param vdop - vdop
 * @param actual - actual
 * @param satellites - satellites
 * @param dimension - dimension
 * @param altitude - altitude
 * @param heading - heading
 * @param speed - speed
 * @param shifted - shifted
 * @return A SDLGPSData object
 */
- (instancetype)initWithLongitudeDegrees:(float)longitudeDegrees latitudeDegrees:(float)latitudeDegrees utcYear:(nullable NSNumber<SDLUInt> *)utcYear utcMonth:(nullable NSNumber<SDLUInt> *)utcMonth utcDay:(nullable NSNumber<SDLUInt> *)utcDay utcHours:(nullable NSNumber<SDLUInt> *)utcHours utcMinutes:(nullable NSNumber<SDLUInt> *)utcMinutes utcSeconds:(nullable NSNumber<SDLUInt> *)utcSeconds compassDirection:(nullable SDLCompassDirection)compassDirection pdop:(nullable NSNumber<SDLFloat> *)pdop hdop:(nullable NSNumber<SDLFloat> *)hdop vdop:(nullable NSNumber<SDLFloat> *)vdop actual:(nullable NSNumber<SDLBool> *)actual satellites:(nullable NSNumber<SDLUInt> *)satellites dimension:(nullable SDLDimension)dimension altitude:(nullable NSNumber<SDLFloat> *)altitude heading:(nullable NSNumber<SDLFloat> *)heading speed:(nullable NSNumber<SDLFloat> *)speed shifted:(nullable NSNumber<SDLBool> *)shifted;

/**
 * longitude degrees
 *
 * Required, Float, -180 - 180
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * latitude degrees
 *
 * Required, Float, -90 - 90
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * utc year
 *
 * Optional, Integer, 2010 - 2100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcYear;

/**
 * utc month
 *
 * Optional, Integer, 1 - 12
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcMonth;

/**
 * utc day
 *
 * Optional, Integer, 1 - 31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcDay;

/**
 * utc hours
 *
 * Optional, Integer, 0 - 23
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcHours;

/**
 * utc minutes
 *
 * Optional, Integer, 0 - 59
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcMinutes;

/**
 * utc seconds
 *
 * Optional, Integer, 0 - 59
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcSeconds;

/**
 * Optional, Potential Compass Directions
 */
@property (nullable, strong, nonatomic) SDLCompassDirection compassDirection;

/**
 * The 3D positional dilution of precision.
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *pdop;

/**
 * The horizontal dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *hdop;

/**
 * the vertical dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *vdop;

/**
 * What the coordinates are based on
 *
 * @discussion YES, if coordinates are based on satellites. NO, if based on dead reckoning.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *actual;

/**
 * The number of satellites in view
 *
 * Optional, Integer, 0 - 31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *satellites;

/**
 * The supported dimensions of the GPS
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLDimension dimension;

/**
 * Altitude in meters
 *
 * Optional, Float, -10000.0 - 10000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *altitude;

/**
 * Heading based on the GPS data.
 * 
 * @discussion North is 0, East is 90, etc. Resolution is 0.01
 *
 * Optional, Float, 0.0 - 359.99
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *heading;

/**
 * Speed in KPH
 *
 * Optional, Float, 0.0 - 500.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * True, if GPS lat/long, time, and altitude have been purposefully shifted (requires a proprietary algorithm to unshift).
 * False, if the GPS data is raw and un-shifted.
 * If not provided, then value is assumed False.
 *
 * Optional, BOOL
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *shifted;

@end

NS_ASSUME_NONNULL_END
