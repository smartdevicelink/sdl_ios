//  SDLImage.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLImageType.h>

/**
 *Specifies, which image shall be used, e.g. in SDLAlerts or on SDLSoftbuttons provided the display supports it.
 *<p><b>Parameter List</b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>value</td>
 * 			<td>NSString* </td>
 * 			<td>Either the static hex icon value or the binary image file name identifier (sent by SDLPutFile).
 * 					<ul>
 *					<li>Min: 0</li>
 *					<li>Max: 65535</li>
 *					</ul>
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>imageType</td>
 * 			<td>SDLImageType* </td>
 * 			<td>Describes, whether it is a static or dynamic image.</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLImage : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLImage object
 */
-(id) init;
/**
 * Constructs a newly allocated SDLImage object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the static hex icon value or the binary image file name identifier (sent by SDLPutFile)
 * @discussion
 */
@property(strong) NSString* value;
/**
 * @abstract the image type
 * @discussion
 */
@property(strong) SDLImageType* imageType;

@end
