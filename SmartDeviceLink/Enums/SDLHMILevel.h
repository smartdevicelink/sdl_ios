//  SDLHMILevel.h
//


#import "SDLEnum.h"

/**
 * Specifies current level of the HMI. An HMI level indicates the degree of user interaction possible through the HMI (e.g. TTS only, display only, VR, etc.). The HMI level varies for an application based on the type of display (i.e. Nav or non-Nav) and the user directing "focus" to other applications (e.g. phone, other mobile applications, etc.)
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLHMILevel SDL_SWIFT_ENUM;

/**
 * The application has full use of the SDL HMI. The app may output via TTS, display, or streaming audio and may gather input via VR, Menu, and button presses
 */
extern SDLHMILevel const SDLHMILevelFull;

/**
 * This HMI Level is only defined for a media application using an HMI with an 8 inch touchscreen (Nav) system. The application's <i>Show</i> text is displayed and it receives button presses from media-oriented buttons (SEEKRIGHT, SEEKLEFT, TUNEUP, TUNEDOWN, PRESET_0-9)
 */
extern SDLHMILevel const SDLHMILevelLimited;

/**
 * App cannot interact with user via TTS, VR, Display or Button Presses. App can perform the following operations:
 *
 * @discussion <ul>
 * <li>Operation : AddCommand</li>
 * <li>Operation : DeleteCommand</li>
 * <li>Operation : AddSubMenu</li>
 * <li>Operation : DeleteSubMenu</li>
 * <li>Operation : CreateInteractionChoiceSet</li>
 * <li>Operation : DeleteInteractionChoiceSet</li>
 * <li>Operation : SubscribeButton</li>
 * <li>Operation : UnsubscribeButton</li>
 * <li>Operation : Show</li>
 * <li>Operation : UnregisterAppInterface</li>
 * <li>Operation : ResetGlobalProperties</li>
 * <li>Operation : SetGlobalProperties</li>
 * </ul>
 */
extern SDLHMILevel const SDLHMILevelBackground;

/**
 * Application has been discovered by SDL, but it cannot send any requests or receive any notifications
 *
 * @discussion An HMILevel of NONE can also mean that the user has exited the application by saying "exit appname" or selecting "exit" from the application's menu. When this happens, the application still has an active interface registration with SDL and all SDL resources the application has created (e.g. Choice Sets, subscriptions, etc.) still exist. But while the HMILevel is NONE, the application cannot send any messages to SYNC, except UnregisterAppInterface
 */
extern SDLHMILevel const SDLHMILevelNone;
