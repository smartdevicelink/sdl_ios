//  SDLEndAudioPassThru.h
//


#import "SDLRPCRequest.h"

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

NS_ASSUME_NONNULL_BEGIN

@interface SDLEndAudioPassThru : SDLRPCRequest

@end

NS_ASSUME_NONNULL_END
