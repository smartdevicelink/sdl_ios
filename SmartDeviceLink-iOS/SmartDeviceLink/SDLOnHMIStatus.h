//  SDLOnHMIStatus.h
//


#import "SDLRPCNotification.h"

#import "SDLHMILevel.h"
#import "SDLAudioStreamingState.h"
#import "SDLSystemContext.h"

/**
 * <p>Notifies an application that HMI conditions have changed for the application. This indicates whether the application
 * can speak phrases, display text, perform interactions, receive button presses and events, stream audio, etc. This
 * notification will be sent to the application when there has been a change in any one or several of the indicated
 * states (<i>SDLHMILevel</i>, <i>SDLAudioStreamingState</i> or <i>SDLSystemContext</i>) for the application</p>
 * <p>All three values are, in principle, independent of each other (though there may be some relationships). A value for
 * one parameter should not be interpreted from the value of another parameter.</p>
 * <p>There are no guarantees about the timeliness or latency of the SDLOnHMIStatus notification. Therefore, for example,
 * information such as <i>SDLAudioStreamingState</i> may not indicate that the audio stream became inaudible to the user
 * exactly when the SDLOnHMIStatus notification was received.</p>
 *
 * <p>
 * <b>Parameter List:</b>
 * <table  border="1" rules="all">
 * <tr>
 * <th>Name</th>
 * <th>Type</th>
 * <th>Description</th>
 * <th>SmartDeviceLink Ver Available</th>
 * </tr>
 * <tr>
 * <td>hmiLevel</td>
 * <td>SDLHMILevel *</td>
 * <td>The current HMI Level in effect for the application.</td>
 * <td>SmartDeviceLink 1.0</td>
 * </tr>
 * <tr>
 * <td>audioStreamingState</td>
 * <td>SDLAudioStreamingState *</td>
 * <td>Current state of audio streaming for the application.
 * When this parameter has a value of NOT_AUDIBLE,
 * the application must stop streaming audio to SDL.
 * Informs app whether any currently streaming audio is
 * audible to user (AUDIBLE) or not (NOT_AUDIBLE). A
 * value of NOT_AUDIBLE means that either the
 * application's audio will not be audible to the user, or
 * that the application's audio should not be audible to
 * the user (i.e. some other application on the mobile
 * device may be streaming audio and the application's
 * audio would be blended with that other audio). </td>
 * <td>SmartDeviceLink 1.0</td>
 * </tr>
 * <tr>
 * <td>systemContext</td>
 * <td>SDLSystemContext *</td>
 * <td>Indicates that a user-initiated interaction is in-progress
 * (VRSESSION or MENU), or not (MAIN)</td>
 * <td>SmartDeviceLink 1.0</td>
 * </tr>
 * </table>
 * </p>
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLRegisterAppInterface
 */
@interface SDLOnHMIStatus : SDLRPCNotification {
}
/**
 *Constructs a newly allocated SDLOnHMIStatus object
 */
- (id)init;
/**
 *<p>Constructs a newly allocated SDLOnHMIStatus object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;
/**
 * @abstract SDLHMILevel in effect for the application
 * @discussion
 */
@property (strong) SDLHMILevel *hmiLevel;
/**
 * @abstract current state of audio streaming for the application
 * @discussion
 */
@property (strong) SDLAudioStreamingState *audioStreamingState;
/**
 * @abstract the System Context
 * @discussion whether a user-initiated interaction is in-progress (VRSESSION or MENU), or not (MAIN)
 */
@property (strong) SDLSystemContext *systemContext;
@end
