//  SDLPrimaryAudioSource.h
//


#import "SDLEnum.h"

/**
 * Reflects the current primary audio source of SDL (if selected).
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLPrimaryAudioSource : SDLEnum {
}

/*!
 @abstract get SDLPrimaryAudioSource according value string
 @param value NSString
 @result SDLPrimaryAudioSource object
 */
+ (SDLPrimaryAudioSource *)valueOf:(NSString *)value;
/*!
 @abstract declare an array to store all possible SDLPrimaryAudioSource values
 @result return the array
 */
+ (NSMutableArray *)values;

/**
 * @abstract Currently no source selected
 * @result return the current primary audio source : <font color=gray><i> NO_SOURCE_SELECTED </i></font>
 */
+ (SDLPrimaryAudioSource *)NO_SOURCE_SELECTED;
/**
 * @abstract USB is current source
 * @result return the current primary audio source : <font color=gray><i> USB </i></font>
 */
+ (SDLPrimaryAudioSource *)USB;
/**
 * @abstract USB2 is current source
 * @result return the current primary audio source : <font color=gray><i> USB2 </i></font>
 */
+ (SDLPrimaryAudioSource *)USB2;
/**
 * @abstract Bluetooth Stereo is current source
 * @result return the current primary audio source : <font color=gray><i> BLUETOOTH_STEREO_BTST </i></font>
 */
+ (SDLPrimaryAudioSource *)BLUETOOTH_STEREO_BTST;
/**
 * @abstract Line in is current source
 * @result return the current primary audio source : <font color=gray><i> LINE_IN </i></font>
 */
+ (SDLPrimaryAudioSource *)LINE_IN;
/**
 * @abstract iPod is current source
 * @result return the current primary audio source : <font color=gray><i> IPOD </i></font>
 */
+ (SDLPrimaryAudioSource *)IPOD;
/**
 * @abstract Mobile app is current source
 * @result return the current primary audio source : <font color=gray><i> MOBILE_APP </i></font>
 */
+ (SDLPrimaryAudioSource *)MOBILE_APP;

@end
