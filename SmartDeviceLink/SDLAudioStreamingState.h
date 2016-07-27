//  SDLAudioStreamingState.h
//


#import "SDLEnum.h"

/**
 * Describes whether or not streaming audio is currently audible to the user. Though provided in every OnHMIStatus notification, this information is only relevant for applications that declare themselves as media apps in RegisterAppInterface
 *
 * @since SDL 1.0
 */
@interface SDLAudioStreamingState : SDLEnum {
}

/**
 * @abstract Convert String to SDLAudioStreamingState
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLAudioStreamingState
 */
+ (SDLAudioStreamingState *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLAudioStreamingState
 *
 * @return an array that store all possible SDLAudioStreamingState
 */
+ (NSArray *)values;
/**
 * @abstract Currently streaming audio, if any, is audible to user.
 *
 * @return SDLAudioStreamingState with value of *AUDIBLE*
 */
+ (SDLAudioStreamingState *)AUDIBLE;

/**
 * @abstract Some kind of audio mixing is taking place. Currently streaming audio, if any, is audible to the user at a lowered volume.
 *
 * @return SDLAudioStreamingState with value of *ATTENUATED*
 *
 * @since SDL 2.0
 */
+ (SDLAudioStreamingState *)ATTENUATED;

/**
 * @abstract Currently streaming audio, if any, is not audible to user. made via VR session.
 *
 * @return SDLAudioStreamingState with value of *NOT_AUDIBLE*
 */
+ (SDLAudioStreamingState *)NOT_AUDIBLE;
@end
