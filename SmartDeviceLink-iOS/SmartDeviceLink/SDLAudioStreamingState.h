//  SDLAudioStreamingState.h
//


#import "SDLEnum.h"

/**
 * Describes whether or not streaming audio is currently audible to the user.
 * Though provided in every OnHMIStatus notification, this information is only
 * relevant for applications that declare themselves as media apps in
 * RegisterAppInterface
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
@interface SDLAudioStreamingState : SDLEnum {
}
/**
 * @abstract Convert String to SDLAudioStreamingState
 * @param value NSString
 * @result SDLAudioStreamingState
 */
+ (SDLAudioStreamingState *)valueOf:(NSString *)value;
/*!
 @abstract Store the enumeration of all possible SDLAudioStreamingState
 @result return an array that store all possible SDLAudioStreamingState
 */
+ (NSMutableArray *)values;
/**
 * @abstract Currently streaming audio, if any, is audible to user.
 * @result SDLAudioStreamingState with value of <font color=gray><i>AUDIBLE</i></font>
 * @since SmartDeviceLink 1.0
 */
+ (SDLAudioStreamingState *)AUDIBLE;
/**
 * @abstract Some kind of audio mixing is taking place. Currently streaming audio, if
 * any, is audible to the user at a lowered volume.
 * @result SDLAudioStreamingState with value of <font color=gray><i>ATTENUATED</i></font>
 * @since SmartDeviceLink 2.0
 */
+ (SDLAudioStreamingState *)ATTENUATED;
/**
 * @abstract Currently streaming audio, if any, is not audible to user. made via VR
 * session.
 * @result SDLAudioStreamingState with value of <font color=gray><i>NOT_AUDIBLE</i></font>
 * @since SmartDeviceLink 1.0
 */
+ (SDLAudioStreamingState *)NOT_AUDIBLE;
@end
