//  SDLAddSubMenu.h


#import "SDLRPCRequest.h"

/**
 * Add a SDLSubMenu to the Command Menu
 * <p>
 * A SDLSubMenu can only be added to the Top Level Menu (i.e.a SDLSubMenu cannot be
 * added to a SDLSubMenu), and may only contain commands as children
 * <p>
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUD</b>
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLDeleteSubMenu SDLAddCommand SDLDeleteCommand
 */
@interface SDLAddSubMenu : SDLRPCRequest {
}

/**
 * Constructs a new SDLAddSubMenu object
 */
- (instancetype)init;
/**
 * Constructs a new SDLAddSubMenu object indicated by the dictionary parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithId:(UInt8)menuId menuName:(NSString *)menuName;

- (instancetype)initWithId:(UInt8)menuId menuName:(NSString *)menuName position:(UInt8)position;

/**
 * @abstract a Menu ID that identifies a sub menu
 * @discussion This value is used in
 * <i>SDLAddCommand</i> to which SDLSubMenu is the parent of the command being added
 * <p>
 */
@property (strong) NSNumber *menuID;
/**
 * @abstract a position of menu
 * @discussion An NSNumber pointer representing the position within the items
 *            of the top level Command Menu. 0 will insert at the front, 1
 *            will insert after the first existing element, etc. Position of
 *            any submenu will always be located before the return and exit
 *            options
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>
 *            Min Value: 0; Max Value: 1000</li>
 *            <li>If position is greater or equal than the number of items
 *            on top level, the sub menu will be appended by the end</li>
 *            <li>If this parameter is omitted, the entry will be added at
 *            the end of the list</li>
 *            </ul>
 */
@property (strong) NSNumber *position;
/**
 * @abstract a menuName which is displayed representing this submenu item
 * @discussion NSString which will be displayed representing this submenu item
 */
@property (strong) NSString *menuName;

@end
