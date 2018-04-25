//  SDLAudioPassThruCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLSamplingRate.h"


/**
 * Describes different audio type configurations for SDLPerformAudioPassThru, e.g. {8kHz,8-bit,PCM}

 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioPassThruCapabilities : SDLRPCStruct

/**
 The sampling rate for AudioPassThru

 Required
 */
@property (strong, nonatomic) SDLSamplingRate samplingRate;

/**
 The sample depth in bit for AudioPassThru

 Required
 */
@property (strong, nonatomic) SDLBitsPerSample bitsPerSample;

/**
 The audiotype for AudioPassThru

 Required
 */
@property (strong, nonatomic) SDLAudioType audioType;

@end

NS_ASSUME_NONNULL_END
