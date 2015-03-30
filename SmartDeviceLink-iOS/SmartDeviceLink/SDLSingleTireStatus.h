//  SDLSingleTireStatus.h
//



#import "SDLRPCMessage.h"

#import "SDLComponentVolumeStatus.h"

/**
 * Tire pressure status of a single tire.
 * <p><b>Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>status</td>
 * 			<td>ComponentVolumeStatus</td>
 * 			<td>Describes the volume status of a single tire
 * 					See ComponentVolumeStatus
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLSingleTireStatus object
 */
-(instancetype) init;

/**
 * @abstract Constructs a newly allocated SDLSingleTireStatus object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The volume status of a single tire
 */
@property(strong) SDLComponentVolumeStatus* status;

@end

