//  SDLAppHMIType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible app hmi types.
 *
 * @since SDL 2.0
 */
@interface SDLAppHMIType : SDLEnum {
}

/**
 * @abstract Convert String to AppHMIType
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLAppHMIType
 */
+ (SDLAppHMIType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLAppHMIType
 *
 * @return an array that store all possible SDLAppHMIType
 */
+ (NSArray *)values;

/**
 * @abstract The App will have default rights.
 *
 * @return SDLAppHMIType with value *DEFAULT*
 */
+ (SDLAppHMIType *)DEFAULT;

/**
 * @abstract Communication type of App
 *
 * @return SDLAppHMIType with value *COMMUNICATION*
 */
+ (SDLAppHMIType *)COMMUNICATION;

/**
 * @abstract App dealing with Media
 *
 * @return SDLAppHMIType with value *MEDIA*
 */
+ (SDLAppHMIType *)MEDIA;

/**
 * @abstract Messaging App
 *
 * @return SDLAppHMIType with value *MESSAGING*
 */
+ (SDLAppHMIType *)MESSAGING;

/**
 * @abstract Navigation App
 *
 * @return SDLAppHMIType with value *NAVIGATION*
 */
+ (SDLAppHMIType *)NAVIGATION;

/**
 * @abstract Information App
 *
 * @return SDLAppHMIType with value *INFORMATION*
 */
+ (SDLAppHMIType *)INFORMATION;

/**
 * @abstract App dealing with social media
 *
 * @return SDLAppHMIType with value *SOCIAL*
 */
+ (SDLAppHMIType *)SOCIAL;

+ (SDLAppHMIType *)BACKGROUND_PROCESS;

/**
 * @abstract App only for Testing purposes
 *
 * @return SDLAppHMIType with value *TESTING*
 */
+ (SDLAppHMIType *)TESTING;

/**
 * @abstract System App
 *
 * @return SDLAppHMIType with value *SYSTEM*
 */
+ (SDLAppHMIType *)SYSTEM;

@end
