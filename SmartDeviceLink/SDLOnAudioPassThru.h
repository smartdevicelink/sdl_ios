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
@interface SDLOnAudioPassThru : SDLRPCNotification

@end
