//  SDLTriggerSource.h
//


#import "SDLEnum.h"

/**
 * Indicates whether choice/command was selected via VR or via a menu selection (using SEEKRIGHT/SEEKLEFT, TUNEUP, TUNEDOWN, OK buttons)
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLTriggerSource SDL_SWIFT_ENUM;

/**
 * @abstract Selection made via menu
 */
extern SDLTriggerSource const SDLTriggerSourceMenu;

/**
 * @abstract Selection made via Voice session
 */
extern SDLTriggerSource const SDLTriggerSourceVoiceRecognition;

/**
 * @abstract Selection made via Keyboard
 */
extern SDLTriggerSource const SDLTriggerSourceKeyboard;
