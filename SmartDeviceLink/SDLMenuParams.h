//  SDLMenuParams.h
//


#import "SDLRPCMessage.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Used when adding a sub menu to an application menu or existing sub menu.
 *
 * @since SDL 1.0
 */
@interface SDLMenuParams : SDLRPCStruct

/// Convenience init with required parameters.
///
/// @param menuName The menu name
/// @return An instance of the add submenu class
- (instancetype)initWithMenuName:(NSString *)menuName;

/// Convenience init with all parameters.
///
/// @param menuName The menu name
/// @param parentId The unique ID of an existing submenu to which a command will be added
/// @param position The position within the items of the parent Command Menu
/// @return An instance of the add submenu class
- (instancetype)initWithMenuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position;

/**
 * The unique ID of an existing submenu to which a command will be added

 * If this element is not provided, the command will be added to the top level of the Command Menu.
 *
 * Optional, Integer, 0 - 2,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *parentID;

/**
 * The position within the items of the parent Command Menu

 * 0 will insert at the front, 1 will insert after the first existing element, etc.
 * 
 * Position of any submenu will always be located before the return and exit options.
 *
 * If position is greater or equal than the number of items in the parent Command Menu, the sub menu will be appended to the end of that Command Menu.
 *
 * If this element is omitted, the entry will be added at the end of the parent menu.
 *
 * Optional, Integer, 0 - 1000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *position;

/**
 * The menu name which appears in menu, representing this command
 * 
 * Required, max length 500 characters
 */
@property (strong, nonatomic) NSString *menuName;

@end

NS_ASSUME_NONNULL_END
