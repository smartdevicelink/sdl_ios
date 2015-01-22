//  SDLEndAudioPassThru.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 * When this request is invoked, the audio capture stops
 * <p>
 * Function Group: AudioPassThru
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 * Since <b>SmartDeviceLink 2.0</b><br>
 * see SDLPerformAudioPassThru
 */
@interface SDLEndAudioPassThru : SDLRPCRequest {}

/**
 * Constructs a new SDLEndAudioPassThru object
 */
-(id) init;
/**
 * Constructs a new SDLEndAudioPassThru object indicated by the NSMutableDictionary
 * parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
