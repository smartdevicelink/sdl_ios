//  SDLOnAudioPassThru.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

/**
 * Binary data is in binary part of hybrid msg.
 *  <p>
 * </p>
 * <b>HMI Status Requirements:</b>
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
 */
@interface SDLOnAudioPassThru : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLOnAudioPassThru object
 */
-(id) init;
/**
 *<p>Constructs a newly allocated SDLOnAudioPassThru object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
