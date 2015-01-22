//  SDLOnPermissionsChange.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

/**
 * Provides update to app of which sets of functions are available
 * <p>
 * </p>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul>
 * <li>Any</li>
 * </ul>
 * AudioStreamingState:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * SystemContext:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * </ul>
 * <p>
 * <b>Parameter List:</b>
 * <table border="1" rules="all">
 * <tr>
 * <th>Name</th>
 * <th>Type</th>
 * <th>Description</th>
 * <th>Req</th>
 * <th>Notes</th>
 * <th>SmartDeviceLink Ver Available</th>
 * </tr>
 * <tr>
 * <td>permissionItem</td>
 * <td>NSMutableArray *</td>
 * <td>Change in permissions for a given set of RPCs</td>
 * <td>Y</td>
 * <td>Minsize=1 Maxsize=100</td>
 * <td>SmartDeviceLink 2.0</td>
 * </tr>
 * </table>
 * </p>
 */
@interface SDLOnPermissionsChange : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLOnPermissionsChange object
 */
-(id) init;
/**
 *<p>Constructs a newly allocated SDLOnPermissionsChange object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract an Array of SDLPermissionItem object describing change in permissions for a given set of RPCs
 * @discussion
 */
@property(strong) NSMutableArray* permissionItem;

@end
