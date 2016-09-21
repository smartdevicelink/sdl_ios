//  SDLAppHMIType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible app hmi types.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLAppHMIType NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract The App will have default rights.
 */
extern SDLAppHMIType SDLAppHMITypeDefault;

/**
 * @abstract Communication type of App
 */
extern SDLAppHMIType SDLAppHMITypeCommunication;

/**
 * @abstract App dealing with Media
 */
extern SDLAppHMIType SDLAppHMITypeMedia;

/**
 * @abstract Messaging App
 */
extern SDLAppHMIType SDLAppHMITypeMessaging;

/**
 * @abstract Navigation App
 */
extern SDLAppHMIType SDLAppHMITypeNavigation;

/**
 * @abstract Information App
 */
extern SDLAppHMIType SDLAppHMITypeInformation;

/**
 * @abstract App dealing with social media
 */
extern SDLAppHMIType SDLAppHMITypeSocial;

extern SDLAppHMIType SDLAppHMITypeBackgroundProcess;

/**
 * @abstract App only for Testing purposes
 */
extern SDLAppHMIType SDLAppHMITypeTesting;

/**
 * @abstract System App
 */
extern SDLAppHMIType SDLAppHMITypeSystem;
