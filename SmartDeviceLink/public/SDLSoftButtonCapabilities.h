//  SDLSoftButtonCapabilities.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a SoftButton's capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLSoftButtonCapabilities : SDLRPCStruct

/**
 * The button supports a short press.
 *
 * Whenever the button is pressed short, onButtonPressed(SHORT) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * The button supports a LONG press.
 *
 * Whenever the button is pressed long, onButtonPressed(LONG) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * The button supports "button down" and "button up".
 *
 * Whenever the button is pressed, onButtonEvent(DOWN) will be invoked. Whenever the button is released, onButtonEvent(UP) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

/**
 * The button supports referencing a static or dynamic image.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *imageSupported;

/**
 The button supports the use of text. If not included, the default value should be considered true that the button will support text.
 
 Optional, Boolean
 
 @since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *textSupported;

@end

NS_ASSUME_NONNULL_END
