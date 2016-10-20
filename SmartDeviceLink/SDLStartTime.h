//  SDLStartTime.h
//


#import "SDLRPCMessage.h"

/**
 * Describes the hour, minute and second values used to set the media clock.
 *
 * @since SDL 1.0
 */
@interface SDLStartTime : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLStartTime object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLStartTime object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds;

/**
 * @abstract The hour of the media clock
 * 
 * @discussion Some display types only support a max value of 19. If out of range, it will be rejected.
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber *hours;

/**
 * @abstract The minute of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber *minutes;

/**
 * @abstract The second of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber *seconds;

@end
