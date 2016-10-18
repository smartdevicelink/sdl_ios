//  SDLSystemContext.h
//


#import "SDLEnum.h"

/**
 * Indicates whether or not a user-initiated interaction is in progress, and if so, in what mode (i.e. MENU or VR).
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSystemContext SDL_SWIFT_ENUM;

/**
 * @abstract No user interaction (user-initiated or app-initiated) is in progress.
 */
extern SDLSystemContext const SDLSystemContextMain;

/**
 * @abstract VR-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextVoiceRecognitionSession;

/**
 * @abstract Menu-oriented, user-initiated or app-initiated interaction is in-progress.
 */
extern SDLSystemContext const SDLSystemContextMenu;

/**
 * @abstract The app's display HMI is currently being obscured by either a system or other app's overlay.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextHMIObscured;

/**
 * @abstract Broadcast only to whichever app has an alert currently being displayed.
 *
 * @since SDL 2.0
 */
extern SDLSystemContext const SDLSystemContextAlert;
