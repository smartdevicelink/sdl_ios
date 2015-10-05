//  SDLOnCommand.h
//

#import "SDLRPCNotification.h"

@class SDLTriggerSource;


/**
 * This is called when a command was selected via VR after pressing the PTT button, or selected from the menu after
 * pressing the MENU button.
 *
 * <b>Note:</b> The sequence of *SDLOnHMIStatus* and *SDLOnCommand* notifications for user-initiated interactions is indeterminate.
 * 
 * @since SDL 1.0
 * @see SDLAddCommand SDLDeleteCommand SDLDeleteSubMenu
 */
@interface SDLOnCommand : SDLRPCNotification {
}

/**
 *Constructs a newly allocated SDLRPCNotification object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLRPCNotification object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The command ID of the command the user selected. This is the command ID value provided by the application in the <i>SDLAddCommand</i> operation that created the command.
 */
@property (strong) NSNumber *cmdID;

/**
 * @abstract Indicates whether command was selected via voice or via a menu selection (using the OK button).
 */
@property (strong) SDLTriggerSource *triggerSource;

@end
