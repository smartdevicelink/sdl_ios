//  SDLSamplingRate.h
//


#import "SDLEnum.h"

/**
 * Describes different sampling rates for PerformAudioPassThru
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLSamplingRate NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract Sampling rate of 8 kHz
 */
extern SDLSamplingRate const SDLSamplingRate8Khz;

/**
 * @abstract Sampling rate of 16 kHz
 */
extern SDLSamplingRate const SDLSamplingRate16Khz;

/**
 * @abstract Sampling rate of 22 kHz
 */
extern SDLSamplingRate const SDLSamplingRate22Khz;

/**
 * @abstract Sampling rate of 44 kHz
 */
extern SDLSamplingRate const SDLSamplingRate44Khz;
