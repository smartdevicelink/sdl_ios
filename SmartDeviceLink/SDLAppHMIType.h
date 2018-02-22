//  SDLAppHMIType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible app hmi types.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLAppHMIType SDL_SWIFT_ENUM;

/**
 * @abstract The App will have default rights.
 */
extern SDLAppHMIType const SDLAppHMITypeDefault;

/**
 * @abstract Communication type of App
 */
extern SDLAppHMIType const SDLAppHMITypeCommunication;

/**
 * @abstract App dealing with Media
 */
extern SDLAppHMIType const SDLAppHMITypeMedia;

/**
 * @abstract Messaging App
 */
extern SDLAppHMIType const SDLAppHMITypeMessaging;

/**
 * @abstract Navigation App
 */
extern SDLAppHMIType const SDLAppHMITypeNavigation;

/**
 * @abstract Information App
 */
extern SDLAppHMIType const SDLAppHMITypeInformation;

/**
 * @abstract App dealing with social media
 */
extern SDLAppHMIType const SDLAppHMITypeSocial;

/**
 * @abstract App dealing with Mobile Projection applications
 */
extern SDLAppHMIType const SDLAppHMITypeProjection;

extern SDLAppHMIType const SDLAppHMITypeBackgroundProcess;

/**
 * @abstract App only for Testing purposes
 */
extern SDLAppHMIType const SDLAppHMITypeTesting;

/**
 * @abstract System App
 */
extern SDLAppHMIType const SDLAppHMITypeSystem;

/**
 * @abstract Remote control */
extern SDLAppHMIType const SDLAppHMITypeRemoteControl;
