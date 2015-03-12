//  SDLOnCommand.h
//

#import "SDLRPCNotification.h"

@class SDLTriggerSource;


/**
 * This is called when a command was selected via VR after pressing the PTT button, or selected from the menu after
 * pressing the MENU button. <p>
 * <b>Note: </b>Sequence of SDLOnHMIStatus and SDLOnCommand notifications for user-initiated interactions is indeterminate.
 * <p></p>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul>
 *   <li>FULL,LIMITED</li>
 * </ul>
 * AudioStreamingState:
 * <ul><li>Any</li></ul>
 * SystemContext:
 * <ul><li>Any</li></ul>
 * </ul>
 * <p>
 * <b>Parameter List:</b>
 * <table  border="1" rules="all">
 *  <tr>
 *      <th>Name</th>
 *      <th>Type</th>
 *      <th>Description</th>
 *      <th>Notes</th>
 *      <th>SmartDeviceLink Ver Available</th>
 * </tr>
 * <tr>
 *      <td>cmdID</td>
 *      <td>NSNumber *</td>
 *      <td>The cmd ID of the command the user selected. This is the cmd ID value provided by the application in the <i>SDLAddCommand</i> operation that created the command.</td>
 *      <td></td>
 *      <td>SmartDeviceLink 1.0</td>
 * </tr>
 * <tr>
 *      <td>triggerSource</td>
 *      <td>SDLTriggerSource *</td>
 *      <td>Indicates whether command was selected via VR or via a menu selection (using the OK button).</td>
 *      <td></td>
 *      <td>SmartDeviceLink 1.0</td>
 * </tr>
 * </table>
 * </p>
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLAddCommand SDLDeleteCommand SDLDeleteSubMenu
 */
@interface SDLOnCommand : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLRPCNotification object
 */
-(id) init;
/**
 *<p>Constructs a newly allocated SDLRPCNotification object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the Command's ID
 * @discussion
 */
@property(strong) NSNumber* cmdID;
/**
 * @abstract the object indicates the command was selected via VR or via a menu selection (using the OK button).
 * @discussion
 */
@property(strong) SDLTriggerSource* triggerSource;

@end
