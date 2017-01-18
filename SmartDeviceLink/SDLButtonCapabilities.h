//  SDLButtonCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLButtonName.h"


/**
 * Provides information about the capabilities of a SDL HMI button.
 * 
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLButtonCapabilities : SDLRPCStruct

/**
 * @abstract The name of the SDL HMI button.
 */
@property (strong, nonatomic) SDLButtonName name;

/**
 * @abstract A NSNumber value indicates whether the button supports a SHORT press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * @abstract A NSNumber value indicates whether the button supports a LONG press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * @abstract A NSNumber value indicates whether the button supports "button down" and "button up"
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

@end

NS_ASSUME_NONNULL_END
