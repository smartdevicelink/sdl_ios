//  SDLChangeRegistration.h
//



#import "SDLRPCRequest.h"

#import "SDLLanguage.h"

/**
 * If the app recognizes during the app registration that the SDL HMI language
 * (voice/TTS and/or display) does not match the app language, the app will be
 * able (but does not need) to change this registration with changeRegistration
 * prior to app being brought into focus
 * <p>
 * Function Group: Base
 * <p>
 * <b>HMILevel can by any</b>
 * <p>
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 * see SDLRegisterAppInterface
 */
@interface SDLChangeRegistration : SDLRPCRequest {}

/**
 * Constructs a new SDLChangeRegistration object
 */
-(id) init;
/**
 * Constructs a new SDLChangeRegistration object indicated by the NSMutableDictionary
 * parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the language app want to change to
 * @discussion
 */
@property(strong) SDLLanguage* language;
/**
 * @abstract  HMI display language
 * @discussion
 */
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
