//  SDLUnsubscribeButton.h
//

#import "SDLRPCRequest.h"

#import "SDLButtonName.h"


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

NS_ASSUME_NONNULL_BEGIN

@interface SDLUnsubscribeButton : SDLRPCRequest

/// Convenience init to unsubscribe from a subscription button
///
/// @param buttonName A name of the button to unsubscribe from
/// @return A name of the button to unsubscribe from
- (instancetype)initWithButtonName:(SDLButtonName)buttonName;

/**
 * A name of the button to unsubscribe from
 * @discussion An Enumeration value, see <i>
 *         SDLButtonName</i>
 */
@property (strong, nonatomic) SDLButtonName buttonName;

@end

NS_ASSUME_NONNULL_END
