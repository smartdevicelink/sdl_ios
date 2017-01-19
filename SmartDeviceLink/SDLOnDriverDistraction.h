//  SDLOnDriverDistraction.h
//

#import "SDLRPCNotification.h"

#import "SDLDriverDistractionState.h"

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

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnDriverDistraction : SDLRPCNotification

/**
 * @abstract The driver distraction state (i.e. whether driver distraction rules are in effect, or not)
 */
@property (strong, nonatomic) SDLDriverDistractionState state;

@end

NS_ASSUME_NONNULL_END
