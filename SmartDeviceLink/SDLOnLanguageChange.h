//  SDLOnLanguageChange.h
//

#import "SDLRPCNotification.h"

#import "SDLLanguage.h"


/**
 * Provides information to what language the SDL HMI language was changed
 *
 * @since SDL 2.0
 */
@interface SDLOnLanguageChange : SDLRPCNotification

/**
 * @abstract Current SDL voice engine (VR+TTS) language
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 * @abstract Current display language
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguage;

@end
