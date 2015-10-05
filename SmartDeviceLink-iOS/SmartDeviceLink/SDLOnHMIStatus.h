//  SDLOnHMIStatus.h
//

#import "SDLRPCNotification.h"

@class SDLAudioStreamingState;
@class SDLHMILevel;
@class SDLSystemContext;


/**
 * Notifies an application that HMI conditions have changed for the application. This indicates whether the application
 * can speak phrases, display text, perform interactions, receive button presses and events, stream audio, etc. This
 * notification will be sent to the application when there has been a change in any one or several of the indicated
 * states (<i>SDLHMILevel</i>, <i>SDLAudioStreamingState</i> or <i>SDLSystemContext</i>) for the application.
 *
 * All three values are, in principle, independent of each other (though there may be some relationships). A value for
 * one parameter should not be interpreted from the value of another parameter.
 *
 * There are no guarantees about the timeliness or latency of the SDLOnHMIStatus notification. Therefore, for example,
 * information such as <i>SDLAudioStreamingState</i> may not indicate that the audio stream became inaudible to the user
 * exactly when the SDLOnHMIStatus notification was received.
 * 
 * @since SDL 1.0
 */
@interface SDLOnHMIStatus : SDLRPCNotification {
}

/**
 *Constructs a newly allocated SDLOnHMIStatus object
 */
- (instancetype)init;

/**
 *<p>Constructs a newly allocated SDLOnHMIStatus object indicated by the dictionary parameter</p>
 *@param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract SDLHMILevel in effect for the application
 */
@property (strong) SDLHMILevel *hmiLevel;

/**
 * @abstract Current state of audio streaming for the application. When this parameter has a value of NOT_AUDIBLE, the application must stop streaming audio to SDL.
 *
 * Informs app whether any currently streaming audio is audible to user (AUDIBLE) or not (NOT_AUDIBLE). A value of NOT_AUDIBLE means that either the application's audio will not be audible to the user, or that the application's audio should not be audible to the user (i.e. some other application on the mobile device may be streaming audio and the application's audio would be blended with that other audio).
 */
@property (strong) SDLAudioStreamingState *audioStreamingState;

/**
 * @abstract the System Context
 * @discussion whether a user-initiated interaction is in-progress (VRSESSION or MENU), or not (MAIN)
 */
@property (strong) SDLSystemContext *systemContext;

@end
