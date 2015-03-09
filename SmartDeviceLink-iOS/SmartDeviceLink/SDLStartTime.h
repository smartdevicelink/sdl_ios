//  SDLStartTime.h
//



#import "SDLRPCMessage.h"

/**
 * Describes the hour, minute and second values used to set the media clock.
 * <p><b> Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>hours</td>
 * 			<td>Int16</td>
 * 			<td>The hour. Minvalue="0", maxvalue="59"
 *					<p><b>Note:</b>Some display types only support a max value of 19. If out of range, it will be rejected.
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>minutes</td>
 * 			<td>Int16</td>
 * 			<td>The minute. Minvalue="0", maxvalue="59".</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>seconds</td>
 * 			<td>Int16</td>
 * 			<td>The second. Minvalue="0", maxvalue="59".</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * </table>
 * Since SmartDeviceLink 1.0
 */
@interface SDLStartTime : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLStartTime object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLStartTime object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The hour. Minvalue="0", maxvalue="59"
 *					<p><b>Note:</b>Some display types only support a max value of 19. If out of range, it will be rejected.
 */
@property(strong) NSNumber* hours;
/**
 * @abstract The minute. Minvalue="0", maxvalue="59".
 */
@property(strong) NSNumber* minutes;
/**
 * @abstract The second. Minvalue="0", maxvalue="59".
 */
@property(strong) NSNumber* seconds;

@end

