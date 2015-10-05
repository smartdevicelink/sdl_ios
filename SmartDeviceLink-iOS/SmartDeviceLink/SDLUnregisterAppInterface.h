//  SDLUnregisterAppInterface.h
//


#import "SDLRPCRequest.h"

/**
 * Terminates an application's interface registration. This causes SDL&reg; to
 * dispose of all resources associated with the application's interface
 * registration (e.g. Command Menu items, Choice Sets, button subscriptions,
 * etc.)
 * <p>
 * After the UnregisterAppInterface operation is performed, no other operations
 * can be performed until a new app interface registration is established by
 * calling <i>{@linkplain RegisterAppInterface}</i>
 * <p>
 * <b>HMILevel can be FULL, LIMITED, BACKGROUND or NONE</b>
 * </p>
 *
 * See SDLRegisterAppInterface SDLOnAppInterfaceUnregistered
 */
@interface SDLUnregisterAppInterface : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLUnregisterAppInterface object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLUnregisterAppInterface object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
