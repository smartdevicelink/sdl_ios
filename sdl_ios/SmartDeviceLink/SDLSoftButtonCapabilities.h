//  SDLSoftButtonCapabilities.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

/**
 * Contains information about a SoftButton's capabilities.
 * <p><b>Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>shortPressAvailable</td>
 * 			<td>Boolean</td>
 * 			<td>The button supports a short press.
 *					Whenever the button is pressed short, onButtonPressed( SHORT) will be invoked.
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>longPressAvailable</td>
 * 			<td>Boolean</td>
 * 			<td>The button supports a LONG press.
 * 					Whenever the button is pressed long, onButtonPressed( LONG) will be invoked.
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>upDownAvailable</td>
 * 			<td>Boolean</td>
 * 			<td>The button supports "button down" and "button up". Whenever the button is pressed, onButtonEvent( DOWN) will be invoked.
 *					Whenever the button is released, onButtonEvent( UP) will be invoked. *
 *			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>imageSupported</td>
 * 			<td>Boolean</td>
 * 			<td>The button supports referencing a static or dynamic image.
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since SmartDeviceLink 2.0
 */
@interface SDLSoftButtonCapabilities : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLSoftButtonCapabilities object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLSoftButtonCapabilities object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The button supports a short press.
 */
@property(strong) NSNumber* shortPressAvailable;
/**
 * @abstract The button supports a LONG press.
 */
@property(strong) NSNumber* longPressAvailable;
/**
 * @abstract The button supports "button down" and "button up".
 */
@property(strong) NSNumber* upDownAvailable;
/**
 * @abstract The button supports referencing a static or dynamic image.
 */
@property(strong) NSNumber* imageSupported;

@end
