//  SDLSystemContext.h
//


#import "SDLEnum.h"

/**
 * Indicates whether or not a user-initiated interaction is in progress, and if so, in what mode (i.e. MENU or VR). Used in OnHMIStatus
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSystemContext NS_TYPED_ENUM;

/**
 * No user interaction (user-initiated or app-initiated) is in progress.
 */
extern SDLSystemContext const SDLSystemContextMain;

/**
 * VR-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextVoiceRecognitionSession;

/**
 * Menu-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextMenu;

/**
 * The app's display HMI is currently being obscured by either a system or other app's overlay.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextHMIObscured;

/**
 * Broadcast only to whichever app has an alert currently being displayed.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextAlert;
