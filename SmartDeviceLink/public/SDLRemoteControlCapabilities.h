//
//  SDLRemoteControlCapabilities.h
//

#import "SDLRPCMessage.h"

@class  SDLAudioControlCapabilities;
@class  SDLButtonCapabilities;
@class  SDLClimateControlCapabilities;
@class  SDLHMISettingsControlCapabilities;
@class  SDLLightControlCapabilities;
@class  SDLRadioControlCapabilities;
@class  SDLSeatControlCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 Capabilities of the remote control feature
 */
@interface SDLRemoteControlCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLRemoteControlCapabilities object with given parameters
 
 @param climateControlCapabilities Array of SDLClimateControlCapabilities
 @param radioControlCapabilities Array of SDLRadioControlCapabilities
 @param buttonCapabilities Array of SDLButtonCapabilities
 @param lightControlCapabilities Array of SDLLightControlCapabilities
 @param seatControlCapabilities Array of SDLSeatControlCapabilities

 @return An instance of the SDLRemoteControlCapabilities class

 */
- (instancetype)initWithClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities seatControlCapabilities:(nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities audioControlCapabilities:(nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities hmiSettingsControlCapabilities:(nullable NSArray<SDLHMISettingsControlCapabilities *> *)hmiSettingsControlCapabilities lightControlCapabilities:(nullable NSArray<SDLLightControlCapabilities *> *)lightControlCapabilities;

/**
 * If included, the platform supports RC climate controls.
 * For this baseline version, maxsize=1. i.e. only one climate control module is supported.
 *
 * Optional, Array of SDLClimateControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLClimateControlCapabilities *> *climateControlCapabilities;

/**
 * If included, the platform supports RC radio controls.
 * For this baseline version, maxsize=1. i.e. only one radio control module is supported.
 *
 * Optional, Array of SDLRadioControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLRadioControlCapabilities *> *radioControlCapabilities;

/**
 * If included, the platform supports RC button controls with the included button names.
 *
 * Optional, Array of SDLButtonCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 * If included, the platform supports seat controls.
 *
 * Optional, Array of SDLSeatControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLSeatControlCapabilities *> *seatControlCapabilities;

/**
 * If included, the platform supports audio controls.
 *
 * Optional, Array of SDLAudioControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLAudioControlCapabilities *> *audioControlCapabilities;

/**
 * If included, the platform supports hmi setting controls.
 *
 * Optional, Array of SDLHMISettingsControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLHMISettingsControlCapabilities *> *hmiSettingsControlCapabilities;

/**
 * If included, the platform supports light controls.
 *
 * Optional, Array of SDLLightControlCapabilities, Array length 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLLightControlCapabilities *> *lightControlCapabilities;

@end

NS_ASSUME_NONNULL_END
