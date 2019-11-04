//  SDLEqualizerSettings.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Defines the each Equalizer channel settings.
 */

@interface SDLEqualizerSettings : SDLRPCStruct

/// Convenience init
/// 
/// @param channelId Read-only channel / frequency name
/// @param channelSetting Reflects the setting, from 0%-100%.
- (instancetype)initWithChannelId:(UInt8)channelId channelSetting:(UInt8)channelSetting;

/**
 * @abstract Read-only channel / frequency name
 * (e.i. "Treble, Midrange, Bass" or "125 Hz")
 *
 * Optional, Max String length 50 chars
 */
@property (nullable, strong, nonatomic) NSString *channelName;


/**
 * @abstract Reflects the setting, from 0%-100%.
 *
 * Required, Integer 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *channelSetting;

/**
 * @abstract id of the channel.
 *
 * Required, Integer 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *channelId;

@end

NS_ASSUME_NONNULL_END
