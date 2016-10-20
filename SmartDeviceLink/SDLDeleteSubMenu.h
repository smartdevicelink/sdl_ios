//  SDLDeleteSubMenu.h
//


#import "SDLRPCRequest.h"

/**
 * Deletes a submenu from the Command Menu
 * <p>
 * <b>Notes: </b>When an app deletes a submenu that has child commands, those
 * child commands are also deleted
 * <p>
 * <b>HMILevel needs to be  FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLAddCommand SDLAddSubMenu SDLDeleteCommand
 */
@interface SDLDeleteSubMenu : SDLRPCRequest {
}

/**
 * Constructs a new SDLDeleteSubMenu object
 */
- (instancetype)init;
/**
 * Constructs a new SDLDeleteSubMenu object indicated by the dictionary parameter<p>
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithId:(UInt32)menuId;

/**
 * @abstract the MenuID that identifies the SDLSubMenu to be delete
 * @discussion  <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong) NSNumber *menuID;

@end
