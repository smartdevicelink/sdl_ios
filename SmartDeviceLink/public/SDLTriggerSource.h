//  SDLTriggerSource.h
//


#import "SDLEnum.h"

/**
 * Indicates whether choice/command was selected via VR or via a menu selection (using SEEKRIGHT/SEEKLEFT, TUNEUP, TUNEDOWN, OK buttons). Used in PerformInteractionResponse and OnCommand.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLTriggerSource NS_TYPED_ENUM;

/**
 * Selection made via menu
 */
extern SDLTriggerSource const SDLTriggerSourceMenu;

/**
 * Selection made via Voice session
 */
extern SDLTriggerSource const SDLTriggerSourceVoiceRecognition;

/**
 * Selection made via Keyboard
 */
extern SDLTriggerSource const SDLTriggerSourceKeyboard;
