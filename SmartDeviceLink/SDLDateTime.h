//  SDLDateTime.h
//

#import "SDLRPCStruct.h"

@interface SDLDateTime : SDLRPCStruct

- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year timezoneMinuteOffset:(UInt8)timezoneMinuteOffset timezoneHourOffset:(int)timezoneHourOffset;

/**
 * @abstract Milliseconds part of time
 *
 * Required, Integer 0 - 999
 */
@property (copy, nonatomic) NSNumber<SDLInt> *millisecond;

/**
 * @abstract Seconds part of time
 *
 * Required, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *second;

/**
 * @abstract Minutes part of time
 *
 * Required, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *minute;

/**
 * @abstract Hour part of time
 *
 * Required, Integer 0 - 23
 */
@property (copy, nonatomic) NSNumber<SDLInt> *hour;

/**
 * @abstract Day of the month
 *
 * Required, Integer 1 - 31
 */
@property (copy, nonatomic) NSNumber<SDLInt> *day;

/**
 * @abstract Month of the year
 *
 * Required, Integer 1 - 12
 */
@property (copy, nonatomic) NSNumber<SDLInt> *month;

/**
 * @abstract The year in YYYY format
 *
 * Required, Max Value 4095
 */
@property (copy, nonatomic) NSNumber<SDLInt> *year;

/**
 * @abstract Time zone offset in Min with regard to UTC
 *
 * Required, Integer 0 - 59
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneMinuteOffset;

/**
 * @abstract Time zone offset in Hours with regard to UTC
 *
 * Required, Integer -12 - 14
 */
@property (copy, nonatomic) NSNumber<SDLInt> *timezoneHourOffset;

@end
