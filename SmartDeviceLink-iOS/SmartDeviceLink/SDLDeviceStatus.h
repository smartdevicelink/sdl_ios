//  SDLDeviceStatus.h
//


#import "SDLRPCMessage.h"

#import "SDLDeviceLevelStatus.h"
#import "SDLPrimaryAudioSource.h"

/**
 * Describes the status related to a connected mobile device or SDL and if or how  it is represented in the vehicle.
 * <p><b>Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>voiceRecOn</td>
 * 			<td>NSNumber * </td>
 * 			<td>Voice recognition is on
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>btIconOn</td>
 * 			<td>NSNumber * </td>
 * 			<td>Bluetooth connection established
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>callActive</td>
 * 			<td>NSNumber * </td>
 * 			<td>A call is being active
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>phoneRoaming</td>
 * 			<td>NSNumber * </td>
 * 			<td>The phone is in roaming mode
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>textMsgAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>A textmessage is available
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>battLevelStatus</td>
 * 			<td>SDLDeviceLevelStatus * </td>
 * 			<td>Battery level status
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>stereoAudioOutputMuted</td>
 * 			<td>NSNumber * </td>
 * 			<td>Status of the stereo audio output channel
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>monoAudioOutputMuted</td>
 * 			<td>NSNumber * </td>
 * 			<td>Status of the mono audio output channel
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>signalLevelStatus</td>
 * 			<td>SDLDeviceLevelStatus * </td>
 * 			<td>Signal level status
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>primaryAudioSource</td>
 * 			<td>PrimaryAudioSource * </td>
 * 			<td>Reflects the current primary audio source of SDL (if selected).
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>eCallEventActive</td>
 * 			<td>NSNumber * </td>
 * 			<td>Reflects, if an eCall event is active
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since <b>SmartDeviceLink 2.0</b>
 */

@interface SDLDeviceStatus : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLDeviceStatus object
 */
- (id)init;
/**
 * Constructs a newly allocated SDLDeviceStatus object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract NSNumber value indicates whether the voice recognition on or off
 * @discussion
 */
@property (strong) NSNumber *voiceRecOn;
/**
 * @abstract NSNumber value indicates whether the bluetooth connection established
 * @discussion
 */
@property (strong) NSNumber *btIconOn;
/**
 * @abstract NSNumber value indicates whether a call is being active
 * @discussion
 */
@property (strong) NSNumber *callActive;
/**
 * @abstract NSNumber value indicates whether the phone is in roaming mode
 * @discussion
 */
@property (strong) NSNumber *phoneRoaming;
/**
 * @abstract NSNumber value indicates whether a textmessage is available
 * @discussion
 */
@property (strong) NSNumber *textMsgAvailable;
/**
 * @abstract battery level status
 * @discussion
 */
@property (strong) SDLDeviceLevelStatus *battLevelStatus;
/**
 * @abstract the status of the stereo audio output channel
 * @discussion
 */
@property (strong) NSNumber *stereoAudioOutputMuted;
/**
 * @abstract the status of the mono audio output channel
 * @discussion
 */
@property (strong) NSNumber *monoAudioOutputMuted;
/**
 * @abstract signal level status
 * @discussion
 */
@property (strong) SDLDeviceLevelStatus *signalLevelStatus;
/**
 * @abstract the current primary audio source of SDL (if selected).
 * @discussion
 */
@property (strong) SDLPrimaryAudioSource *primaryAudioSource;
@property (strong) NSNumber *eCallEventActive;

@end
