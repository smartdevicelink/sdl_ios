//  SDLDeliveryMode.h
//

#import "SDLEnum.h"

/**
 *Specifies the mode in which the sendLocation request is sent.
 */
@interface SDLDeliveryMode : SDLEnum

/**
 * @abstract Convert String to SDLDeliveryMode
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLDeliveryMode
 */
+ (SDLDeliveryMode *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLDeliveryMode
 *
 * @return an array that store all possible SDLDeliveryMode
 */
+ (NSArray *)values;

/**
 * @abstract User is prompted on HMI
 *
 * @return a SDLDeliveryMode with value of *PROMPT*
 */
+ (SDLDeliveryMode *)PROMPT;

/**
 * @abstract Set the location as destination without prompting the user
 *
 * @return a SDLDeliveryMode with value of *DESTINATION*
 */
+ (SDLDeliveryMode *)DESTINATION;

/**
 * @abstract Adds the current location to navigation queue
 *
 * @return a SDLDeliveryMode with value of *QUEUE*
 */
+ (SDLDeliveryMode *)QUEUE;

@end
