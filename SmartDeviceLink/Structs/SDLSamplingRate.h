//  SDLSamplingRate.h
//


#import "SDLEnum.h"

/**
 * Describes different sampling rates for PerformAudioPassThru
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLSamplingRate SDL_SWIFT_ENUM;

/**
 * @abstract Sampling rate of 8 kHz
 */
extern SDLSamplingRate const SDLSamplingRate8KHZ;

/**
 * @abstract Sampling rate of 16 kHz
 */
extern SDLSamplingRate const SDLSamplingRate16KHZ;

/**
 * @abstract Sampling rate of 22 kHz
 */
extern SDLSamplingRate const SDLSamplingRate22KHZ;

/**
 * @abstract Sampling rate of 44 kHz
 */
extern SDLSamplingRate const SDLSamplingRate44KHZ;
