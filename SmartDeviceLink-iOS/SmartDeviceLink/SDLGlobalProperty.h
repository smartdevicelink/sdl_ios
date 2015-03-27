//  SDLGlobalProperty.h
//



#import "SDLEnum.h"

/**
 * Properties of a user-initiated VR interaction (i.e. interactions started by the user pressing the PTT button).
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLGlobalProperty : SDLEnum {}

/**
 * Convert String to SDLGlobalProperty
 * @param value String
 * @return SDLGlobalProperty
 */
+(SDLGlobalProperty*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLGlobalProperty
 @result return an array that store all possible SDLGlobalProperty
 */
+(NSMutableArray*) values;

/**
 * @abstract The help prompt to be spoken if the user needs assistance during a user-initiated interaction.
 * @result return a SDLGlobalProperty with value of <font color=gray><i> HELPPROMPT </i></font>
 */
+(SDLGlobalProperty*) HELPPROMPT;
/**
 * @abstract The prompt to be spoken if the user-initiated interaction times out waiting for the user's verbal input.
 * @result return a SDLGlobalProperty with value of <font color=gray><i> TIMEOUTPROMPT </i></font>
 */
+(SDLGlobalProperty*) TIMEOUTPROMPT;
+(SDLGlobalProperty*) VRHELPTITLE;
+(SDLGlobalProperty*) VRHELPITEMS;
+(SDLGlobalProperty*) MENUNAME;
+(SDLGlobalProperty*) MENUICON;
+(SDLGlobalProperty*) KEYBOARDPROPERTIES;

@end