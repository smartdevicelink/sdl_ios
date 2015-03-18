//  SDLSyncMsgVersion.h
//


#import "SDLRPCMessage.h"

/**
 * Specifies the version number of the SDL V4 interface. This is used by both the application and SDL to declare what interface version each is using.
 * <p><b> Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>majorVersion</td>
 * 			<td>Int16</td>
 * 			<td>
 * 					<ul>
 * 					<li>minvalue="1"</li>
 * 				    <li>maxvalue="10"</li>
 *					</ul>
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>minorVersion</td>
 * 			<td>Int16</td>
 * 			<td>
 * 					<ul>
 * 					<li>minvalue="0"</li>
 * 				    <li>maxvalue="1000"</li>
 *					</ul>
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * </table>
 * Since SmartDeviceLink 1.0
 */
@interface SDLSyncMsgVersion : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLSyncMsgVersion object
 */
- (id)init;
/**
 * @abstract Constructs a newly allocated SDLSyncMsgVersion object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Major version
 * 					<ul>
 * 					<li>minvalue="1"</li>
 * 				    <li>maxvalue="10"</li>
 *					</ul>
 */
@property (strong) NSNumber *majorVersion;
/**
 * @abstract Minor version
 * 					<ul>
 * 					<li>minvalue="0"</li>
 * 				    <li>maxvalue="1000"</li>
 *					</ul>
 */
@property (strong) NSNumber *minorVersion;

@end
