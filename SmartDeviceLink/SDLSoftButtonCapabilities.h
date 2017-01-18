//  SDLSoftButtonCapabilities.h
//


#import "SDLRPCMessage.h"

/**
 * Contains information about a SoftButton's capabilities.
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonCapabilities : SDLRPCStruct

/**
 * @abstract The button supports a short press.
 *
 * @discussion Whenever the button is pressed short, onButtonPressed(SHORT) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * @abstract The button supports a LONG press.
 *
 * @discussion Whenever the button is pressed long, onButtonPressed(LONG) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * @abstract The button supports "button down" and "button up".
 *
 * @discussion Whenever the button is pressed, onButtonEvent(DOWN) will be invoked. Whenever the button is released, onButtonEvent(UP) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

/**
 * @abstract The button supports referencing a static or dynamic image.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *imageSupported;

@end

NS_ASSUME_NONNULL_END
