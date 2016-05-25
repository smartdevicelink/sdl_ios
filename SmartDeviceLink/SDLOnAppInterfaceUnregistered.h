//  SDLOnAppInterfaceUnregistered.h
//

#import "SDLRPCNotification.h"

@class SDLAppInterfaceUnregisteredReason;


/**
 * Notifies an application that its interface registration has been terminated. This means that all SDL resources associated with the application are discarded, including the Command Menu, Choice Sets, button subscriptions, etc.
 *
 * For more information about SDL resources related to an interface registration, see <i>SDLRegisterAppInterface</i>.
 * 
 * @since SDL 1.0
 * @see SDLRegisterAppInterface
 */
@interface SDLOnAppInterfaceUnregistered : SDLRPCNotification {
}

/**
 * Constructs a newly allocated SDLOnAppInterfaceUnregistered object
 */
- (instancetype)init;
/**
 * Constructs a newly allocated SDLOnAppInterfaceUnregistered object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The reason application's interface was terminated
 */
@property (strong) SDLAppInterfaceUnregisteredReason *reason;

@end
