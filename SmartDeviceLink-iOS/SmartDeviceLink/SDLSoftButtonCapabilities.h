//  SDLSoftButtonCapabilities.h
//


#import "SDLRPCMessage.h"

/**
 * Contains information about a SoftButton's capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLSoftButtonCapabilities : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLSoftButtonCapabilities object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLSoftButtonCapabilities object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The button supports a short press.
 *
 * @discussion Whenever the button is pressed short, onButtonPressed(SHORT) will be invoked.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *shortPressAvailable;

/**
 * @abstract The button supports a LONG press.
 *
 * @discussion Whenever the button is pressed long, onButtonPressed(LONG) will be invoked.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *longPressAvailable;

/**
 * @abstract The button supports "button down" and "button up".
 *
 * @discussion Whenever the button is pressed, onButtonEvent(DOWN) will be invoked. Whenever the button is released, onButtonEvent(UP) will be invoked.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *upDownAvailable;

/**
 * @abstract The button supports referencing a static or dynamic image.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *imageSupported;

@end
