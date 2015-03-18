//  SDLButtonCapabilities.h
//


#import "SDLRPCMessage.h"

#import "SDLButtonName.h"

/**
 * Provides information about the capabilities of a SDL HMI button.
 * <p><b> Parameter List </b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>name</td>
 * 			<td>SDLButtonName</td>
 * 			<td>The name of the SDL HMI button.</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>shortPressAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports a SHORT press. See SDLButtonPressMode for more information.</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>longPressAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports a LONG press. See SDLButtonPressMode for more information.</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>upDownAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports "button down" and "button up". When the button is depressed, the <i>SDLOnButtonEvent</i> notification will be invoked with a value of BUTTONDOWN.
 *                  <p> When the button is released, the <i>SDLOnButtonEvent</i> notification will be invoked with a value of BUTTONUP.</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * </table>
 * Since <b>SmartDeviceLink 1.0</b><br>
 */
@interface SDLButtonCapabilities : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLButtonCapabilities object
 */
- (id)init;
/**
 * Constructs a newly allocated SDLButtonCapabilities object indicated by the Hashtable parameter
 * @param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The name of the SDL HMI button.
 * @discussion
 */
@property (strong) SDLButtonName *name;
/**
 * @abstract A NSNumber value indicates whether the button supports a SHORT press
 * @discussion
 */
@property (strong) NSNumber *shortPressAvailable;
/**
 * @abstract A NSNumber value indicates whether the button supports a LONG press
 * @discussion
 */
@property (strong) NSNumber *longPressAvailable;
/**
 * @abstract A NSNumber value indicates whether the button supports "button down" and "button up"
 * @discussion
 */
@property (strong) NSNumber *upDownAvailable;

@end
