//  SDLSamplingRate.h
//


#import "SDLEnum.h"

/**
 * Describes different sampling rates for PerformAudioPassThru
 *
 */
@interface SDLSamplingRate : SDLEnum {
}

/*!
 @abstract get SDLSamplingRate according value string
 @param value NSString
 @result SDLSamplingRate object
 */
+ (SDLSamplingRate *)valueOf:(NSString *)value;
/*!
 @abstract declare an array to store all possible SDLSamplingRate values
 @result return the array
 */
+ (NSMutableArray *)values;

/**
 * @abstract Sampling rate of 8 kHz
 * @result return SamplingRate of <font color=gray><i> 8KHZ </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+ (SDLSamplingRate *)_8KHZ;
/**
 * @abstract Sampling rate of 16 kHz
 * @result return SamplingRate of <font color=gray><i> 16KHZ </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+ (SDLSamplingRate *)_16KHZ;
/**
 * @abstract Sampling rate of 22 kHz
 * @result return SamplingRate of <font color=gray><i> 22KHZ </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+ (SDLSamplingRate *)_22KHZ;
/**
 * @abstract Sampling rate of 44 kHz
 * @result return SamplingRate of <font color=gray><i> 44KHZ </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+ (SDLSamplingRate *)_44KHZ;

@end
