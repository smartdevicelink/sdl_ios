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
 Initialize an SDLStartTime with hours, minutes, and seconds.

 @param hours Hours
 @param minutes Minutes
 @param seconds Seconds
 @return The SDLStartTime object
 */
- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds;

/**
 Initialize an SDLStartTime with an NSTimeInterval (a Double of seconds)

 @param timeInterval The time interval to convert into an SDLStartTime
 @return The SDLStartTime object
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

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
