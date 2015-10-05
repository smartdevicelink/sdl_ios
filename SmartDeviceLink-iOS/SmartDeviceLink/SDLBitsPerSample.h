//  SDLBitsPerSample.h
//


#import "SDLEnum.h"

/**
 * Describes different bit depth options for PerformAudioPassThru
 *
 * @since SDL 2.0
 */
@interface SDLBitsPerSample : SDLEnum {
}

/**
 * @abstract Convert String to SDLBitsPerSample
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLBitsPerSample
 */
+ (SDLBitsPerSample *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLBitsPerSample
 *
 * @return an array that store all possible SDLBitsPerSample
 */
+ (NSArray *)values;

/**
 * @abstract 8 bits per sample
 *
 * @return a SDLBitsPerSample with value of *8_BIT*
 */
+ (SDLBitsPerSample *)_8_BIT;

/**
 * @abstract 16 bits per sample
 *
 * @return a SDLBitsPerSample with value of *16_BIT*
 */
+ (SDLBitsPerSample *)_16_BIT;

@end
