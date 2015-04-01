//  SDLOnDriverDistraction.h
//



#import "SDLRPCNotification.h"

#import "SDLDriverDistractionState.h"

/**
 * <p>Notifies the application of the current driver distraction state (whether driver distraction rules are in effect, or
 * not).</p>
 *
 * <p></p>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul><li>Can be sent with FULL, LIMITED or BACKGROUND</li></ul>
 * AudioStreamingState:
 * <ul><li>Any</li></ul>
 * SystemContext:
 * <ul><li>Any</li></ul>
 * </ul>
 * <p></p>
 * <b>Parameter List:</b>
 * <table  border="1" rules="all">
 *     <tr>
 *         <th>Name</th>
 *         <th>Type</th>
 *         <th>Description</th>
 *         <th>SmartDeviceLink Ver Available</th>
 *     </tr>
 *     <tr>
 *         <td>state</td>
 *         <td>SDLDriverDistractionState* </td>
 *         <td>Current driver distraction <i>state</i>(i.e. whether driver distraction rules are in effect, or not). </td>
 *         <td>SmartDeviceLink 1.0</td>
 *     </tr>
 * </table>
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLOnDriverDistraction : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLOnDriverDistraction object
 */
-(instancetype) init;
/**
 *<p>Constructs a newly allocated SDLOnDriverDistraction object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the driver distraction state(i.e. whether driver distraction rules are in effect, or not)
 * @discussion
 */
@property(strong) SDLDriverDistractionState* state;

@end
