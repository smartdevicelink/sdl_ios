//  SDLOnCommand.h
//

#import "SDLRPCNotification.h"

#import "SDLTriggerSource.h"

/**
 This is called when a command was selected via VR after pressing the PTT button, or selected from the menu after pressing the MENU button.

 Note: The sequence of *SDLOnHMIStatus* and *SDLOnCommand* notifications for user-initiated interactions is indeterminate.

 @since SDL 1.0
 @see SDLAddCommand SDLDeleteCommand SDLDeleteSubMenu
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnCommand : SDLRPCNotification

/**
 The command ID of the command the user selected. This is the command ID value provided by the application in the SDLAddCommand operation that created the command.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *cmdID;

/**
 Indicates whether command was selected via voice or via a menu selection (using the OK button).
 */
@property (strong, nonatomic) SDLTriggerSource triggerSource;

@end

NS_ASSUME_NONNULL_END
