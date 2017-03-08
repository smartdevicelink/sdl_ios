//  SDLGlobalProperty.h
//


#import "SDLEnum.h"

/**
 * Properties of a user-initiated VR interaction (i.e. interactions started by the user pressing the PTT button).
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLGlobalProperty SDL_SWIFT_ENUM;

/**
 * @abstract The help prompt to be spoken if the user needs assistance during a user-initiated interaction.
 */
extern SDLGlobalProperty const SDLGlobalPropertyHelpPrompt;

/**
 * @abstract The prompt to be spoken if the user-initiated interaction times out waiting for the user's verbal input.
 */
extern SDLGlobalProperty const SDLGlobalPropertyTimeoutPrompt;

extern SDLGlobalProperty const SDLGlobalPropertyVoiceRecognitionHelpTitle;

extern SDLGlobalProperty const SDLGlobalPropertyVoiceRecognitionHelpItems;

extern SDLGlobalProperty const SDLGlobalPropertyMenuName;

extern SDLGlobalProperty const SDLGlobalPropertyMenuIcon;

extern SDLGlobalProperty const SDLGlobalPropertyKeyboard;
