//  SDLChangeRegistration.h
//



#import "SDLRPCRequest.h"

@class SDLLanguage;

/**
 * If the app recognizes during the app registration that the SDL HMI language (voice/TTS and/or display) does not match the app language, the app will be able (but does not need) to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Function Group: Base
 *
 * HMILevel can by any
 *
 * @since SDL 2.0
 */
@interface SDLChangeRegistration : SDLRPCRequest {}

/**
 * Constructs a new SDLChangeRegistration object
 */
-(instancetype) init;

/**
 * Constructs a new SDLChangeRegistration object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The language the app wants to change to
 */
@property(strong) SDLLanguage* language;

/**
 * @abstract HMI display language
 */
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
