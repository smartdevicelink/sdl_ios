//  SDLAudioControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLPrimaryAudioSource.h"

@class SDLEqualizerSettings;

NS_ASSUME_NONNULL_BEGIN

/**
 The audio control data information.

 @since RPC 5.0
 */
@interface SDLAudioControlData : SDLRPCStruct


/**
 Constructs a newly allocated SDLAudioControlData object with given parameters

 @param source current primary audio source of the system.
 @param keepContext Whether or not application's context is changed.
 @param volume Reflects the volume of audio.
 @param equalizerSettings list of supported Equalizer channels.
 @return An instance of the SDLAudioControlData class.
 */
- (instancetype)initWithSource:(nullable SDLPrimaryAudioSource)source keepContext:(nullable NSNumber<SDLBool> *)keepContext volume:(nullable NSNumber<SDLInt> *)volume equalizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings;

/**
 * @abstract   In a getter response or a notification,
 * it is the current primary audio source of the system.
 * In a setter request, it is the target audio source that the system shall switch to.
 * If the value is MOBILE_APP, the system shall switch to the mobile media app that issues the setter RPC.
 *
 * Optional, SDLPrimaryAudioSource
 */
@property (nullable, strong, nonatomic) SDLPrimaryAudioSource source;

/**
 * @abstract This parameter shall not be present in any getter responses or notifications.
 * This parameter is optional in a setter request. The default value is false.
 * If it is true, the system not only changes the audio source but also brings the default
 * infotainment system UI associated with the audio source to foreground and set the application to background.
 * If it is false, the system changes the audio source, but keeps the current application's context.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *keepContext;

/**
 * @abstract Reflects the volume of audio, from 0%-100%.
 *
 * Required, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *volume;

/**
 * @abstract Defines the list of supported channels (band) and their current/desired settings on HMI
 *
 * Required, Array of SDLEqualizerSettings with minSize:1 maxSize:100
 */
@property (nullable, strong, nonatomic) NSArray<SDLEqualizerSettings *> *equalizerSettings;

@end

NS_ASSUME_NONNULL_END
