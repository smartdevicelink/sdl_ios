//  SDLDeviceStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLDeviceLevelStatus.h"
#import "SDLPrimaryAudioSource.h"


/**
 Describes the status related to a connected mobile device or SDL and if or how  it is represented in the vehicle.

 @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeviceStatus : SDLRPCStruct

/**
 * Indicates whether the voice recognition is on or off
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *voiceRecOn;

/**
 * Indicates whether the bluetooth connection established
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *btIconOn;

/**
 * Indicates whether a call is being active
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *callActive;

/**
 * Indicates whether the phone is in roaming mode
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *phoneRoaming;

/**
 * Indicates whether a textmessage is available
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *textMsgAvailable;

/**
 * Battery level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong, nonatomic) SDLDeviceLevelStatus battLevelStatus;

/**
 * The status of the stereo audio output channel
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *stereoAudioOutputMuted;

/**
 * The status of the mono audio output channel
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *monoAudioOutputMuted;

/**
 * Signal level status
 *
 * @see SDLDeviceLevelStatus
 *
 * Required
 */
@property (strong, nonatomic) SDLDeviceLevelStatus signalLevelStatus;

/**
 * The current primary audio source of SDL (if selected).
 *
 * @see SDLPrimaryAudioSource
 * 
 * Required
 */
@property (strong, nonatomic) SDLPrimaryAudioSource primaryAudioSource;

/**
 * Indicates if an emergency call is active
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *eCallEventActive;

@end

NS_ASSUME_NONNULL_END
