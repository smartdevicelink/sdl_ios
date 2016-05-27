//  SDLSystemContext.h
//


#import "SDLEnum.h"

/**
 * Indicates whether or not a user-initiated interaction is in progress, and if so, in what mode (i.e. MENU or VR).
 *
 * @since SDL 1.0
 */
@interface SDLSystemContext : SDLEnum {
}

/**
 * Convert String to SDLSystemContext
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLSystemContext
 */
+ (SDLSystemContext *)valueOf:(NSString *)value;

/**
 *  @abstract Store the enumeration of all possible SDLSystemContext
 *
 *  @return an array that store all possible SDLSystemContext
 */
+ (NSArray *)values;

/**
 * @abstract No user interaction (user-initiated or app-initiated) is in progress.
 *
 * @return SDLSystemContext object of value *MAIN*
 */
+ (SDLSystemContext *)MAIN;

/**
 * @abstract VR-oriented, user-initiated or app-initiated interaction is in-progress.
 *
 * @return SDLSystemContext object of value *VRSESSION*
 */
+ (SDLSystemContext *)VRSESSION;

/**
 * @abstract Menu-oriented, user-initiated or app-initiated interaction is in-progress.
 *
 * @return SDLSystemContext object of value *MENU*
 */
+ (SDLSystemContext *)MENU;

/**
 * @abstract The app's display HMI is currently being obscured by either a system or other app's overlay.
 *
 * @return SDLSystemContext object of value *HMI_OBSCURED*
 *
 * @since SDL 2.0
 */
+ (SDLSystemContext *)HMI_OBSCURED;

/**
 * @abstract Broadcast only to whichever app has an alert currently being displayed.
 *
 * @return SDLSystemContext object of value *ALERT*
 *
 * @since SDL 2.0
 */
+ (SDLSystemContext *)ALERT;

@end
