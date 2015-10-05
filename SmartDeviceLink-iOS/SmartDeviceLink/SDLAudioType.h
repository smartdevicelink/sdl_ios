//  SDLAudioType.h
//


#import "SDLEnum.h"

/**
 Describes different audio type options for PerformAudioPassThru
 */
@interface SDLAudioType : SDLEnum {
}

/**
 * @abstract Convert String to SDLAudioType
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLAudioType
 */
+ (SDLAudioType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLAudioType
 *
 * @return an array that store all possible SDLAudioType
 */
+ (NSArray *)values;

/**
 * @abstract PCM raw audio
 *
 * @return SDLAudioType with value of *PCM*
 *
 * @since SDL 2.0
 */
+ (SDLAudioType *)PCM;

@end