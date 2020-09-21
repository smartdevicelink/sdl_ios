//  SDLAudioStreamingIndicator.h
//

#import "SDLEnum.h"


/**
 * Enumeration listing possible indicators of audio streaming changes
 *
 * @since SDL 4.6
 */
typedef SDLEnum SDLAudioStreamingIndicator NS_TYPED_ENUM;

/**
 * Default playback indicator.
 * By default the playback indicator should be PLAY_PAUSE when:
 * - the media app is newly registered on the head unit (after RegisterAppInterface)
 * - the media app was closed by the user (App enteres HMI_NONE)
 * - the app sends SetMediaClockTimer with audioStreamingIndicator not set to any value
 */
extern SDLAudioStreamingIndicator const SDLAudioStreamingIndicatorPlayPause;

/**
 * Indicates that a button press of the Play/Pause button starts the audio playback.
 */
extern SDLAudioStreamingIndicator const SDLAudioStreamingIndicatorPlay;

/**
 * Indicates that a button press of the Play/Pause button pauses the current audio playback.
 */
extern SDLAudioStreamingIndicator const SDLAudioStreamingIndicatorPause;

/**
 * Indicates that a button press of the Play/Pause button stops the current audio playback.
 */
extern SDLAudioStreamingIndicator const SDLAudioStreamingIndicatorStop;
