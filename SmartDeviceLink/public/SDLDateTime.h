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

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A struct referenced in SendLocation for an absolute date
 */
@interface SDLDateTime : SDLRPCStruct

/**
 * @param millisecond - millisecond
 * @param second - second
 * @param minute - minute
 * @param hour - hour
 * @param day - day
 * @param month - month
 * @param year - year
 * @param tz_hour - tz_hour
 * @param tz_minute - tz_minute
 * @return A SDLDateTime object
 */
- (instancetype)initWithMillisecond:(nullable NSNumber<SDLUInt> *)millisecond second:(nullable NSNumber<SDLUInt> *)second minute:(nullable NSNumber<SDLUInt> *)minute hour:(nullable NSNumber<SDLUInt> *)hour day:(nullable NSNumber<SDLUInt> *)day month:(nullable NSNumber<SDLUInt> *)month year:(nullable NSNumber<SDLInt> *)year tz_hour:(nullable NSNumber<SDLInt> *)tz_hour tz_minute:(nullable NSNumber<SDLUInt> *)tz_minute;

/// Convenience init for creating a date
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute __deprecated_msg("Use initWithMillisecond:second:minute:hour:day:month:year:tz_hour:tz_minute:");

/// Convenience init for creating a date
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @param second Seconds part of time
/// @param millisecond Milliseconds part of time
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond __deprecated_msg("Use initWithMillisecond:second:minute:hour:day:month:year:tz_hour:tz_minute:");

/// Convenience init for creating a date
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @param second Seconds part of time
/// @param millisecond Milliseconds part of time
/// @param day Day of the month
/// @param month Month of the year
/// @param year The year in YYYY format
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year __deprecated_msg("Use initWithMillisecond:second:minute:hour:day:month:year:tz_hour:tz_minute:");

/// Convenience init for creating a date with all properties
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @param second Seconds part of time
/// @param millisecond Milliseconds part of time
/// @param day Day of the month
/// @param month Month of the year
/// @param year The year in YYYY format
/// @param timezoneMinuteOffset Time zone offset in Min with regard to UTC
/// @param timezoneHourOffset Time zone offset in Hours with regard to UTC
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year timezoneMinuteOffset:(UInt8)timezoneMinuteOffset timezoneHourOffset:(int)timezoneHourOffset __deprecated_msg("Use initWithMillisecond:second:minute:hour:day:month:year:tz_hour:tz_minute:");

/**
 * Milliseconds part of time
 *
 * Optional, Integer 0 - 999
 */
@property (copy, nonatomic) NSNumber<SDLInt> *millisecond;

/**
 * Seconds part of time
 *
 * Optional, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *second;

/**
 * Minutes part of time
 *
 * Optional, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *minute;

/**
 * Hour part of time
 *
 * Optional, Integer 0 - 23
 */
@property (copy, nonatomic) NSNumber<SDLInt> *hour;

/**
 * Day of the month
 *
 * Optional, Integer 1 - 31
 */
@property (copy, nonatomic) NSNumber<SDLInt> *day;

/**
 * Month of the year
 *
 * Optional, Integer 1 - 12
 */
@property (copy, nonatomic) NSNumber<SDLInt> *month;

/**
 * The year in YYYY format
 *
 * Optional, Max Value 4095
 */
@property (copy, nonatomic) NSNumber<SDLInt> *year;

/**
 * Time zone offset in Hours wrt UTC.
 * {"num_min_value": -12, "num_max_value": 14, "default_value": 0}
 *
 * @added in SmartDeviceLink 4.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *tz_hour;

/**
 * Time zone offset in Min wrt UTC.
 * {"num_min_value": 0, "num_max_value": 59, "default_value": 0}
 *
 * @added in SmartDeviceLink 4.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *tz_minute;

/**
 * Time zone offset in Min with regard to UTC
 *
 * Optional, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneMinuteOffset __deprecated_msg("Use tz_minute instead");

/**
 * Time zone offset in Hours with regard to UTC
 *
 * Optional, Integer -12 - 14
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneHourOffset __deprecated_msg("Use tz_hour instead");

@end

NS_ASSUME_NONNULL_END
