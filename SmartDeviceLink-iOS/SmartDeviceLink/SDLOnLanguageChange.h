//  SDLOnLanguageChange.h
//

#import "SDLRPCNotification.h"

@class SDLLanguage;


/**
 * Provides information to what language the SDL HMI language was changed
 *
 * @since SDL 2.0
 */
@interface SDLOnLanguageChange : SDLRPCNotification {
}

/**
 *Constructs a newly allocated SDLOnLanguageChange object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLOnLanguageChange object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Current SDL voice engine (VR+TTS) language
 */
@property (strong) SDLLanguage *language;

/**
 * @abstract Current display language
 */
@property (strong) SDLLanguage *hmiDisplayLanguage;

@end
