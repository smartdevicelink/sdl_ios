//  SDLMenuParams.h
//



#import "SDLRPCMessage.h"

/**
 * Used when adding a sub menu to an application menu or existing sub menu.
 * <p><b> Parameter List</b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>parentID</td>
 * 			<td> NSNumber * </td>
 * 			<td>The unique ID of an existing submenu to which a command will be added.
 *					If this element is not provided, the command will be added to the top level of the Command Menu.
 *					<ul>
 *					<li>Min: 0</li>
 *					<li>Max: 2000000000</li>
 *					</ul>
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>position</td>
 * 			<td> NSNumber * </td>
 * 			<td>Position within the items of the parent Command Menu. 0 will insert at the front, 1 will insert after the first existing element, etc.
 * 					Position of any submenu will always be located before the return and exit options.
 * 					<ul>
 * 						<li>Min Value: 0</li>
 * 						<li>Max Value: 1000</li>
 * 						<li>If position is greater or equal than the number of items in the parent Command Menu, the sub menu will be appended to the end of that Command Menu.</li>
 * 						<li>If this element is omitted, the entry will be added at the end of the parent menu.</li>
 * 					</ul>
 * 			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>menuName</td>
 * 			<td> NSString* </td>
 * 			<td>Text which appears in menu, representing this command.
 *       			<ul>
 * 						<li>Min: 1</li>
 * 						<li>Max: 100</li>
 * 					</ul>
 * 			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * </table>
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLMenuParams : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLMenuParams object
 */
-(instancetype) init;
/**
 * Constructs a newly allocated SDLMenuParams object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the unique ID of an existing submenu to which a command will be added
 * @discussion If this element is not provided, the command will be added to the top level of the Command Menu.  Min: 0; Max: 2000000000
 */
@property(strong) NSNumber* parentID;
/**
 * @abstract the position within the items of the parent Command Menu
 * @discussion 0 will insert at the front, 1 will insert after the first existing element, etc.
 * 	Position of any submenu will always be located before the return and exit options.
 * 					<ul>
 * 						<li>Min Value: 0</li>
 * 						<li>Max Value: 1000</li>
 * 						<li>If position is greater or equal than the number of items in the parent Command Menu, the sub menu will be appended to the end of that Command Menu.</li>
 * 						<li>If this element is omitted, the entry will be added at the end of the parent menu.</li>
 * 					</ul>
 */
@property(strong) NSNumber* position;
/**
 * @abstract the menu name which appears in menu, representing this command
 * @discussion
 */
@property(strong) NSString* menuName;

@end
