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

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteSubMenu : SDLRPCRequest

/// Convenience init to delete a submenu
/// 
/// @param menuId Identifies the SDLSubMenu to be delete
/// @return An SDLDeleteSubMenu object
- (instancetype)initWithId:(UInt32)menuId;

/**
 * the MenuID that identifies the SDLSubMenu to be delete
 * @discussion  <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *menuID;

@end

NS_ASSUME_NONNULL_END
