//  SDLAudioControlCapabilities.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioControlCapabilities : SDLRPCStruct

- (instancetype)initWithModuleName:(NSString *)name;

- (instancetype)initWithModuleName:(NSString *)name sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable volueAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)channelID;

/**
 * @abstract    The short friendly name of the light control module.
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
