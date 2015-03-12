//  SDLBitsPerSample.h
//



#import "SDLEnum.h"

/**
 * Describes different bit depth options for PerformAudioPassThru
 *
 */
@interface SDLBitsPerSample : SDLEnum {}

/**
 * @abstract Convert String to SDLBitsPerSample
 * @param value NSString
 * @result SDLBitsPerSample
 */
+(SDLBitsPerSample*) valueOf:(NSString*) value;

/**
 @abstract Store the enumeration of all possible SDLBitsPerSample
 @result return an array that store all possible SDLBitsPerSample
 */
+(NSMutableArray*) values;

/**
 * @abstract 8 bits per sample
 * @since <font color=red><b>SmartDeviceLink 2.0</b></font>
 * @result return a SDLBitsPerSample with value of <font color=gray></i>8_bit</i></font>
 */
+(SDLBitsPerSample*) _8_BIT;

/**
 * @abstract 16 bits per sample
 * @since <font color=red><b>SmartDeviceLink 2.0</b></font>
 * @result return a SDLBitsPerSample with value of <font color=gray></i>16_bit</i></font>
 */
+(SDLBitsPerSample*) _16_BIT;

@end
