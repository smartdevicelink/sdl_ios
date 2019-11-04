//  SDLDateTime.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A struct referenced in SendLocation for an absolute date
 */
@interface SDLDateTime : SDLRPCStruct

/// Convenience init for creating a date
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute;

/// Convenience init for creating a date
///
/// @param hour Hour part of time
/// @param minute Minutes part of time
/// @param second Seconds part of time
/// @param millisecond Milliseconds part of time
/// @return An SDLDateTime object
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond;

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
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year;

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
- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year timezoneMinuteOffset:(UInt8)timezoneMinuteOffset timezoneHourOffset:(int)timezoneHourOffset;

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
 * Time zone offset in Min with regard to UTC
 *
 * Optional, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneMinuteOffset;

/**
 * Time zone offset in Hours with regard to UTC
 *
 * Optional, Integer -12 - 14
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneHourOffset;

@end

NS_ASSUME_NONNULL_END
