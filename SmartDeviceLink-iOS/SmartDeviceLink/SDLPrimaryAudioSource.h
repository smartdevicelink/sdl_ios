//  SDLPrimaryAudioSource.h
//


#import "SDLEnum.h"

/**
 * Reflects the current primary audio source of SDL (if selected).
 *
 * @since SDL 2.0
 */
@interface SDLPrimaryAudioSource : SDLEnum {
}

/**
 * @abstract get SDLPrimaryAudioSource according value string
 *
 * @param value String value to retrieve the object enum for
 *
 * @return SDLPrimaryAudioSource object
 */
+ (SDLPrimaryAudioSource *)valueOf:(NSString *)value;

/**
 * @abstract declare an array to store all possible SDLPrimaryAudioSource values
 * @return the array
 */
+ (NSArray *)values;

/**
 * @abstract Currently no source selected
 * @return the current primary audio source: *NO_SOURCE_SELECTED*
 */
+ (SDLPrimaryAudioSource *)NO_SOURCE_SELECTED;

/**
 * @abstract USB is current source
 * @return the current primary audio source: *USB*
 */
+ (SDLPrimaryAudioSource *)USB;

/**
 * @abstract USB2 is current source
 * @return the current primary audio source: *USB2*
 */
+ (SDLPrimaryAudioSource *)USB2;

/**
 * @abstract Bluetooth Stereo is current source
 * @return the current primary audio source: *BLUETOOTH_STEREO_BTST*
 */
+ (SDLPrimaryAudioSource *)BLUETOOTH_STEREO_BTST;

/**
 * @abstract Line in is current source
 * @return the current primary audio source: *LINE_IN*
 */
+ (SDLPrimaryAudioSource *)LINE_IN;

/**
 * @abstract iPod is current source
 * @return the current primary audio source: *IPOD*
 */
+ (SDLPrimaryAudioSource *)IPOD;

/**
 * @abstract Mobile app is current source
 * @return the current primary audio source: *MOBILE_APP*
 */
+ (SDLPrimaryAudioSource *)MOBILE_APP;

@end
