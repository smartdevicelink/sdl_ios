//  SDLAudioStreamingState.h
//


#import "SDLEnum.h"

/**
 * Describes whether or not streaming audio is currently audible to the user. Though provided in every OnHMIStatus notification, this information is only relevant for applications that declare themselves as media apps in RegisterAppInterface
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLAudioStreamingState NS_TYPED_ENUM;

/**
 * Currently streaming audio, if any, is audible to user.
 */
extern SDLAudioStreamingState const SDLAudioStreamingStateAudible;

/**
 * Some kind of audio mixing is taking place. Currently streaming audio, if any, is audible to the user at a lowered volume.
 *
 * @since SDL 2.0
 */
extern SDLAudioStreamingState const SDLAudioStreamingStateAttenuated;

/**
 * Currently streaming audio, if any, is not audible to user. made via VR session.
 */
extern SDLAudioStreamingState const SDLAudioStreamingStateNotAudible;
