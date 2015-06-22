//  SDLLanguage.h
//


#import "SDLEnum.h"

/**
 * Specifies the language to be used for TTS, VR, displayed messages/menus
 *
 * @since SDL 1.0
 */
@interface SDLLanguage : SDLEnum {
}

/**
 * @abstract Get a Langusge according to a String
 *
 * @param value The value of the string to get an object for
 *
 * @return The Language
 */
+ (SDLLanguage *)valueOf:(NSString *)value;

/**
 * @abstract store all possible Language values
 *
 * @return an array with all possible Language values inside
 */
+ (NSArray *)values;
/*!
 @abstract English_US
 */
+ (SDLLanguage *)EN_US;

/**
 @abstract Spanish - Mexico
 */
+ (SDLLanguage *)ES_MX;

/**
 * @abstract French - Canada
 */
+ (SDLLanguage *)FR_CA;

/**
 * @abstract German - Germany
 */
+ (SDLLanguage *)DE_DE;

/**
 * @abstract Spanish - Spain
 */
+ (SDLLanguage *)ES_ES;

/**
 @abstract English - Great Britain
 */
+ (SDLLanguage *)EN_GB;

/**
 * @abstract Russian - Russia
 */
+ (SDLLanguage *)RU_RU;

/**
 * @abstract Turkish - Turkey
 */
+ (SDLLanguage *)TR_TR;

/**
 * @abstract Polish - Poland
 */
+ (SDLLanguage *)PL_PL;

/**
 * @abstract French - France
 */
+ (SDLLanguage *)FR_FR;

/**
 * @abstract Italian - Italy
 */
+ (SDLLanguage *)IT_IT;

/**
 * @abstract Swedish - Sweden
 */
+ (SDLLanguage *)SV_SE;

/**
 * @abstract Portuguese - Portugal
 */
+ (SDLLanguage *)PT_PT;

/**
 * @abstract Dutch (Standard) - Netherlands
 */
+ (SDLLanguage *)NL_NL;

/**
 * @abstract English - Australia
 */
+ (SDLLanguage *)EN_AU;

/**
 * @abstract Mandarin - China
 */
+ (SDLLanguage *)ZH_CN;

/**
 * @abstract Mandarin - Taiwan
 */
+ (SDLLanguage *)ZH_TW;

/**
 * @abstract Japanese - Japan
 */
+ (SDLLanguage *)JA_JP;

/**
 * @abstract Arabic - Saudi Arabia
 */
+ (SDLLanguage *)AR_SA;

/**
 * @abstract Korean - South Korea
 */
+ (SDLLanguage *)KO_KR;

/**
 * @abstract Portuguese - Brazil
 */
+ (SDLLanguage *)PT_BR;

/**
 * @abstract Czech - Czech Republic
 */
+ (SDLLanguage *)CS_CZ;

/**
 * @abstract Danish - Denmark
 */
+ (SDLLanguage *)DA_DK;

/**
 * @abstract Norwegian - Norway
 */
+ (SDLLanguage *)NO_NO;

@end
