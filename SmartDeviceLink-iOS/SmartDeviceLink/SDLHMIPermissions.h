//  SDLHMIPermissions.h
//



#import "SDLRPCMessage.h"

/**
 * Defining sets of HMI levels, which are permitted or prohibited for a given RPC.
 * <p><b>Parameter List </b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>allowed</td>
 * 			<td>NSMutableArray* </td>
 * 			<td>A set of all HMI levels that are permitted for this given RPC.
 * 					<ul>
 *					<li>Min: 0</li>
 *					<li>Max: 100</li>
 *					</ul>
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>userDisallowed</td>
 * 			<td>NSMutableArray* </td>
 * 			<td>A set of all HMI levels that are prohibated for this given RPC.
 * 					<ul>
 *					<li>Min: 0</li>
 *					<li>Max: 100</li>
 *					</ul>
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLHMIPermissions : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLHMIPermissions object
 */
-(instancetype) init;
/**
 * Constructs a newly allocated SDLHMIPermissions object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract a set of all HMI levels that are permitted for this given RPC
 * @discussion
 */
@property(strong) NSMutableArray* allowed;
/**
 * @abstract a set of all HMI levels that are prohibited for this given RPC
 * @discussion
 */
@property(strong) NSMutableArray* userDisallowed;

@end
