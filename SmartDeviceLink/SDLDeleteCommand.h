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
@interface SDLDeleteCommand : SDLRPCRequest {
}

/**
 * Constructs a new SDLDeleteCommand object
 */
- (instancetype)init;
/**
 * Constructs a new SDLDeleteCommand object indicated by the NSMutableDictionary
 * parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithId:(UInt32)commandId;

/**
 * @abstract the Command ID that identifies the Command to be deleted from Command Menu
 * @discussion an NSNumber value representing Command ID
 *            <p>
 *            <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong) NSNumber *cmdID;

@end
