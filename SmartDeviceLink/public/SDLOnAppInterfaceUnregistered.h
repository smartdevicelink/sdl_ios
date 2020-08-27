//  SDLOnAppInterfaceUnregistered.h
//

#import "SDLRPCNotification.h"

#import "SDLAppInterfaceUnregisteredReason.h"


/**
 * Notifies an application that its interface registration has been terminated. This means that all SDL resources associated with the application are discarded, including the Command Menu, Choice Sets, button subscriptions, etc.
 *
 * For more information about SDL resources related to an interface registration, see <i>SDLRegisterAppInterface</i>.
 * 
 * @since SDL 1.0
 * @see SDLRegisterAppInterface
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnAppInterfaceUnregistered : SDLRPCNotification

/**
 * The reason application's interface was terminated
 */
@property (strong, nonatomic) SDLAppInterfaceUnregisteredReason reason;

@end

NS_ASSUME_NONNULL_END
