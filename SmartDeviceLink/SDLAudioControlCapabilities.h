//  SDLAudioControlCapabilities.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioControlCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLAudioControlCapabilities object with audio control module name (max 100 chars)

 @param name The short friendly name of the audio control module.
 @return An instance of the SDLAudioControlCapabilities class.
 */
- (instancetype)initWithModuleName:(NSString *)name;

/**
  Constructs a newly allocated SDLAudioControlCapabilities object with given parameters

 @param name The short friendly name of the audio control module.
 @param sourceAvailable Availability of the control of audio source.
 @param volumeAvailable Availability of the volume of audio source.
 @param equalizerAvailable Availability of the equalizer of audio source.
 @param equalizerMaxChannelID Equalizer channel ID (between 1-100).
 @return An instance of the SDLAudioControlCapabilities class.
 */
- (instancetype)initWithModuleName:(NSString *)name sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable keepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable volumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)equalizerMaxChannelID;

/**
 * @abstract The short friendly name of the audio control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Availability of the control of audio source.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *sourceAvailable;

/**
 Availability of the keepContext parameter.

 Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *keepContextAvailable;

/**
 * @abstract Availability of the control of audio volume.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *volumeAvailable;

/**
 * @abstract Availability of the control of Equalizer Settings.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *equalizerAvailable;

/**
 * @abstract Must be included if equalizerAvailable=true,
 * and assume all IDs starting from 1 to this value are valid
 *
 * Optional, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *equalizerMaxChannelId;

@end

NS_ASSUME_NONNULL_END
