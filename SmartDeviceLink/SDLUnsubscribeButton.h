//  SDLUnsubscribeButton.h
//

#import "SDLRPCRequest.h"

@class SDLButtonName;


/**
 * Deletes a subscription to button notifications for the specified button. For
 * more information about button subscriptions, see SDLSubscribeButton
 * <p>
 * Application can unsubscribe from a button that is currently being pressed
 * (i.e. has not yet been released), but app will not get button event
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * <p>
 
 * @since SmartDeviceLink 1.0<br/>
 * See SDLSubscribeButton
 */
@interface SDLUnsubscribeButton : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLUnsubscribeButton object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLUnsubscribeButton object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithButtonName:(SDLButtonName *)buttonName;

/**
 * @abstract A name of the button to unsubscribe from
 * @discussion An Enumeration value, see <i>
 *         SDLButtonName</i>
 */
@property (strong) SDLButtonName *buttonName;

@end
