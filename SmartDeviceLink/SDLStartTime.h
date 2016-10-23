//  SDLStartTime.h
//


#import "SDLRPCMessage.h"

/**
 * Describes the hour, minute and second values used to set the media clock.
 *
 * @since SDL 1.0
 */
@interface SDLStartTime : SDLRPCStruct

/**
 * @abstract The hour of the media clock
 * 
 * @discussion Some display types only support a max value of 19. If out of range, it will be rejected.
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber<SDLInt> *hours;

/**
 * @abstract The minute of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber<SDLInt> *minutes;

/**
 * @abstract The second of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber<SDLInt> *seconds;

@end
