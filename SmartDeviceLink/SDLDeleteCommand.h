//  SDLDeleteCommand.h
//


#import "SDLRPCRequest.h"

/**
 * Removes a command from the Command Menu
 * <p>
 * <b>HMI Status Requirements:</b><br/>
 * HMILevel: FULL, LIMITED or BACKGROUND<br/>
 * AudioStreamingState: N/A<br/>
 * SystemContext: Should not be attempted when VRSESSION or MENU
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLAddCommand SDLAddSubMenu SDLDeleteSubMenu
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteCommand : SDLRPCRequest

/// Convenience init to remove a command from the menu
///
/// @param commandId The Command ID that identifies the Command to be deleted from Command Menu
/// @return An SDLDeleteCommand object
- (instancetype)initWithId:(UInt32)commandId;

/**
 * the Command ID that identifies the Command to be deleted from Command Menu
 * @discussion an NSNumber value representing Command ID
 *            <p>
 *            <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *cmdID;

@end

NS_ASSUME_NONNULL_END
