//  SDLDeviceStatus.h
//

#import "SDLRPCMessage.h"

@class SDLDeviceLevelStatus;
@class SDLPrimaryAudioSource;


/**
 * Describes the status related to a connected mobile device or SDL and if or how  it is represented in the vehicle.
 *
 * Parameter List
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
 * @since SDL 2.0
 */
@interface SDLDeviceStatus : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLDeviceStatus object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLDeviceStatus object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use to construct the object
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Indicates whether the voice recognition is on or off
 *
 * Required, Boolean
 */
@property (strong) NSNumber *voiceRecOn;

/**
 * @abstract Indicates whether the bluetooth connection established
 *
 * Required, Boolean
 */
@property (strong) NSNumber *btIconOn;

/**
 * @abstract Indicates whether a call is being active
 *
 * Required, Boolean
 */
@property (strong) NSNumber *callActive;

/**
 * @abstract Indicates whether the phone is in roaming mode
 *
 * Required, Boolean
 */
@property (strong) NSNumber *phoneRoaming;

/**
 * @abstract Indicates whether a textmessage is available
 *
 * Required, Boolean
 */
@property (strong) NSNumber *textMsgAvailable;

/**
 * @abstract Battery level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong) SDLDeviceLevelStatus *battLevelStatus;

/**
 * @abstract The status of the stereo audio output channel
 *
 * Required, Boolean
 */
@property (strong) NSNumber *stereoAudioOutputMuted;

/**
 * @abstract The status of the mono audio output channel
 *
 * Required, Boolean
 */
@property (strong) NSNumber *monoAudioOutputMuted;

/**
 * @abstract Signal level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong) SDLDeviceLevelStatus *signalLevelStatus;

/**
 * @abstract The current primary audio source of SDL (if selected).
 *
 * @see SDLPrimaryAudioSource
 * 
 * Required
 */
@property (strong) SDLPrimaryAudioSource *primaryAudioSource;

/**
 * @abstract Indicates if an emergency call is active
 *
 * Required, Boolean
 */
@property (strong) NSNumber *eCallEventActive;

@end
