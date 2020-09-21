//  SDLSamplingRate.h
//


#import "SDLEnum.h"

/**
 Describes different sampling rates for PerformAudioPassThru and AudioPassThruCapabilities

 @since SDL 2.0
 */
typedef SDLEnum SDLSamplingRate NS_TYPED_ENUM;

/**
 Sampling rate of 8 kHz
 */
extern SDLSamplingRate const SDLSamplingRate8KHZ;

/**
 * Sampling rate of 16 kHz
 */
extern SDLSamplingRate const SDLSamplingRate16KHZ;

/**
 * Sampling rate of 22 kHz
 */
extern SDLSamplingRate const SDLSamplingRate22KHZ;

/**
 * Sampling rate of 44 kHz
 */
extern SDLSamplingRate const SDLSamplingRate44KHZ;
