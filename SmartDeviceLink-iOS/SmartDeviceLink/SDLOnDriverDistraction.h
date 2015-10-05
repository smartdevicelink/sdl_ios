//  SDLOnDriverDistraction.h
//

#import "SDLRPCNotification.h"

@class SDLDriverDistractionState;


/**
 * Notifies the application of the current driver distraction state (whether driver distraction rules are in effect, or
 * not).
 *
 * HMI Status Requirements:
 *
 * <ul>
 * HMILevel:
 * <ul><li>Can be sent with FULL, LIMITED or BACKGROUND</li></ul>
 * AudioStreamingState:
 * <ul><li>Any</li></ul>
 * SystemContext:
 * <ul><li>Any</li></ul>
 * </ul>
 *
 * @since SDL 1.0
 */
@interface SDLOnDriverDistraction : SDLRPCNotification {
}

/**
 * Constructs a newly allocated SDLOnDriverDistraction object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLOnDriverDistraction object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The driver distraction state (i.e. whether driver distraction rules are in effect, or not)
 */
@property (strong) SDLDriverDistractionState *state;

@end
