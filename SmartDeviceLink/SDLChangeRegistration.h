//  SDLChangeRegistration.h
//


#import "SDLRPCRequest.h"
#import "SDLLanguage.h"

@class SDLTTSChunk;

/**
 * If the app recognizes during the app registration that the SDL HMI language (voice/TTS and/or display) does not match the app language, the app will be able (but does not need) to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Any HMILevel allowed
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLChangeRegistration : SDLRPCRequest

- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage;

- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage appName:(nullable NSString *)appName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName ngnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms;

/**
 * @abstract The language the app wants to change to
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 * @abstract HMI display language
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguage;

/**
 *  Request a new app name registration
 *
 *  Optional, Max string length 100 chars
 */
@property (nullable, copy, nonatomic) NSString *appName;

/**
 *  Request a new TTSName registration.
 *
 *  Optional, Array of SDLTTSChunk, 1 - 100 elements
 */
@property (nullable, copy, nonatomic) NSArray<SDLTTSChunk *> *ttsName;

/**
 *  Request a new app short name registration
 *
 *  Optional, Max string length 100 chars
 */
@property (nullable, copy, nonatomic) NSString *ngnMediaScreenAppName;

/**
 *  Request a new VR synonyms registration
 *
 *  Optional, Array of NSString, 1 - 100 elements, max string length 40 chars
 */
@property (nullable, copy, nonatomic) NSArray<NSString *> *vrSynonyms;

@end

NS_ASSUME_NONNULL_END
