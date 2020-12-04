//  SDLGlobalProperty.h
//


#import "SDLEnum.h"

/**
 * Properties of a user-initiated VR interaction (i.e. interactions started by the user pressing the PTT button). Used in RPCs related to ResetGlobalProperties
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLGlobalProperty NS_TYPED_ENUM;

/**
 * The help prompt to be spoken if the user needs assistance during a user-initiated interaction.
 */
extern SDLGlobalProperty const SDLGlobalPropertyHelpPrompt;

/**
 * The prompt to be spoken if the user-initiated interaction times out waiting for the user's verbal input.
 */
extern SDLGlobalProperty const SDLGlobalPropertyTimeoutPrompt;

/**
 * The title of the menu displayed when the user requests help via voice recognition.
 */
extern SDLGlobalProperty const SDLGlobalPropertyVoiceRecognitionHelpTitle;

/**
 * Items of the menu displayed when the user requests help via voice recognition.
 */
extern SDLGlobalProperty const SDLGlobalPropertyVoiceRecognitionHelpItems;

/**
 * The name of the menu button displayed in templates
 */
extern SDLGlobalProperty const SDLGlobalPropertyMenuName;

/**
 * An icon on the menu button displayed in templates
 */
extern SDLGlobalProperty const SDLGlobalPropertyMenuIcon;

/**
 * Property related to the keyboard
 */
extern SDLGlobalProperty const SDLGlobalPropertyKeyboard;

/**
 * Location of the user's seat of setGlobalProperties
 */
extern SDLGlobalProperty const SDLGlobalPropertyUserLocation;
