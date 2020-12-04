//  SDLOnLanguageChange.h
//

#import "SDLRPCNotification.h"

#import "SDLLanguage.h"


/**
 * Provides information to what language the SDL HMI language was changed
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnLanguageChange : SDLRPCNotification

/**
 Current SDL voice engine (VR+TTS) language
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 Current display language
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguage;

@end

NS_ASSUME_NONNULL_END
