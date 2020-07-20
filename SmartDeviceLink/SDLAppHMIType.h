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
 * The App will have default rights.
 */
extern SDLAppHMIType const SDLAppHMITypeDefault;

/**
 * Communication type of App
 */
extern SDLAppHMIType const SDLAppHMITypeCommunication;

/**
 * App dealing with Media
 */
extern SDLAppHMIType const SDLAppHMITypeMedia;

/**
 * Messaging App
 */
extern SDLAppHMIType const SDLAppHMITypeMessaging;

/**
 * Navigation App
 */
extern SDLAppHMIType const SDLAppHMITypeNavigation;

/**
 * Information App
 */
extern SDLAppHMIType const SDLAppHMITypeInformation;

/**
 * App dealing with social media
 */
extern SDLAppHMIType const SDLAppHMITypeSocial;

/**
 * App dealing with Mobile Projection applications
 */
extern SDLAppHMIType const SDLAppHMITypeProjection;

/**
 * App designed for use in the background
 */
extern SDLAppHMIType const SDLAppHMITypeBackgroundProcess;

/**
 * App only for Testing purposes
 */
extern SDLAppHMIType const SDLAppHMITypeTesting;

/**
 * System App
 */
extern SDLAppHMIType const SDLAppHMITypeSystem;

/**
 * Remote control */
extern SDLAppHMIType const SDLAppHMITypeRemoteControl;


/**
 * WebEngine Projection mode
 *
 *  @since 7.0
 */
extern SDLAppHMIType const SDLAppHMITypeWebView;
