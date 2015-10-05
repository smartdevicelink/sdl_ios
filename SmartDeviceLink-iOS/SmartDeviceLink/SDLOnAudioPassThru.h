//  SDLOnAudioPassThru.h
//


#import "SDLRPCNotification.h"

/**
 * Binary data is in binary part of hybrid msg.
 *
 * HMI Status Requirements:
 * <ul>
 * HMILevel:
 * <ul>
 * <li>BACKGROUND, FULL, LIMITED</li>
 * </ul>
 * AudioStreamingState:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * SystemContext:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * </ul>
 */
@interface SDLOnAudioPassThru : SDLRPCNotification {
}

/**
 *Constructs a newly allocated SDLOnAudioPassThru object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLOnAudioPassThru object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
@end
