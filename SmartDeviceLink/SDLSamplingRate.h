//  SDLSamplingRate.h
//


#import "SDLEnum.h"

/**
 * Describes different sampling rates for PerformAudioPassThru
 *
 * @since SDL 2.0
 */
@interface SDLSamplingRate : SDLEnum {
}

/**
 * @abstract get SDLSamplingRate according value string
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLSamplingRate object
 */
+ (SDLSamplingRate *)valueOf:(NSString *)value;

/**
 * @abstract declare an array to store all possible SDLSamplingRate values
 *
 * @return the array
 */
+ (NSArray *)values;

/**
 * @abstract Sampling rate of 8 kHz
 *
 * @return SamplingRate of *8KHZ*
 */
+ (SDLSamplingRate *)_8KHZ;
/**
 * @abstract Sampling rate of 16 kHz
 *
 * @return SamplingRate of *16KHZ*
 */
+ (SDLSamplingRate *)_16KHZ;
/**
 * @abstract Sampling rate of 22 kHz
 *
 * @return SamplingRate of *22KHZ*
 */
+ (SDLSamplingRate *)_22KHZ;
/**
 * @abstract Sampling rate of 44 kHz
 *
 * @return SamplingRate of *44KHZ*
 */
+ (SDLSamplingRate *)_44KHZ;

@end
