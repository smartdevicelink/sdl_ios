//  SDLStartTime.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the hour, minute and second values used to set the media clock.
 *
 * @since SDL 1.0
 */
@interface SDLStartTime : SDLRPCStruct

/**
 Create a time struct with a time interval (time in seconds). Fractions of the second will be eliminated and rounded down.

 @param timeInterval The time interval to transform into hours, minutes, seconds
 @return The object
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 Create a time struct with hours, minutes, and seconds

 @param hours The number of hours
 @param minutes The number of minutes
 @param seconds The number of seconds
 @return The object
 */
- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds;

/**
 * The hour of the media clock
 * 
 * Some display types only support a max value of 19. If out of range, it will be rejected.
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *hours;

/**
 * The minute of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *minutes;

/**
 * The second of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *seconds;

@end

NS_ASSUME_NONNULL_END
