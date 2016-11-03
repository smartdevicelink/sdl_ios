//  SDLMenuParams.h
//


#import "SDLRPCMessage.h"

/**
 * Used when adding a sub menu to an application menu or existing sub menu.
 *
 * @since SDL 1.0
 */
@interface SDLMenuParams : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLMenuParams object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLMenuParams object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithMenuName:(NSString *)menuName;

- (instancetype)initWithMenuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position;

/**
 * @abstract the unique ID of an existing submenu to which a command will be added
 * @discussion If this element is not provided, the command will be added to the top level of the Command Menu.
 *
 * Optional, Integer, 0 - 2,000,000,000
 */
@property (strong) NSNumber *parentID;

/**
 * @abstract The position within the items of the parent Command Menu
 * @discussion 0 will insert at the front, 1 will insert after the first existing element, etc.
 * 
 * Position of any submenu will always be located before the return and exit options.
 *
 * * If position is greater or equal than the number of items in the parent Command Menu, the sub menu will be appended to the end of that Command Menu.
 *
 * * If this element is omitted, the entry will be added at the end of the parent menu.
 *
 * Optional, Integer, 0 - 1000
 */
@property (strong) NSNumber *position;

/**
 * @abstract the menu name which appears in menu, representing this command
 * 
 * Required, max length 500 characters
 */
@property (strong) NSString *menuName;

@end
