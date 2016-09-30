//  SDLButtonCapabilities.h
//

#import "SDLRPCMessage.h"

@class SDLButtonName;


/**
 * Provides information about the capabilities of a SDL HMI button.
 * 
 * @since SDL 1.0
 */
@interface SDLButtonCapabilities : SDLRPCStruct

/**
 * @abstract The name of the SDL HMI button.
 */
@property (strong) SDLButtonName *name;

/**
 * @abstract A NSNumber value indicates whether the button supports a SHORT press
 *
 * Required, Boolean
 */
@property (strong) NSNumber *shortPressAvailable;

/**
 * @abstract A NSNumber value indicates whether the button supports a LONG press
 *
 * Required, Boolean
 */
@property (strong) NSNumber *longPressAvailable;

/**
 * @abstract A NSNumber value indicates whether the button supports "button down" and "button up"
 *
 * Required, Boolean
 */
@property (strong) NSNumber *upDownAvailable;

@end
