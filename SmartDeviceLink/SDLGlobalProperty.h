//  SDLGlobalProperty.h
//


#import "SDLEnum.h"

/**
 * Properties of a user-initiated VR interaction (i.e. interactions started by the user pressing the PTT button).
 *
 * @since SDL 1.0
 */
@interface SDLGlobalProperty : SDLEnum {
}

/**
 * Convert String to SDLGlobalProperty
 * @param value The value of the string to get an object for
 * @return SDLGlobalProperty
 */
+ (SDLGlobalProperty *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLGlobalProperty
 * @return An array that store all possible SDLGlobalProperty
 */
+ (NSArray *)values;

/**
 * @abstract The help prompt to be spoken if the user needs assistance during a user-initiated interaction.
 * @return A SDLGlobalProperty with value of *HELPPROMPT*
 */
+ (SDLGlobalProperty *)HELPPROMPT;

/**
 * @abstract The prompt to be spoken if the user-initiated interaction times out waiting for the user's verbal input.
 * @return A SDLGlobalProperty with value of *TIMEOUTPROMPT*
 */
+ (SDLGlobalProperty *)TIMEOUTPROMPT;

+ (SDLGlobalProperty *)VRHELPTITLE;

+ (SDLGlobalProperty *)VRHELPITEMS;

+ (SDLGlobalProperty *)MENUNAME;

+ (SDLGlobalProperty *)MENUICON;

+ (SDLGlobalProperty *)KEYBOARDPROPERTIES;

@end