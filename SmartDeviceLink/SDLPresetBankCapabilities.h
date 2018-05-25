//  SDLPresetBankCapabilities.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about on-screen preset capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLPresetBankCapabilities : SDLRPCStruct

/**
 * If Onscreen custom presets are available.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *onScreenPresetsAvailable;

@end

NS_ASSUME_NONNULL_END
