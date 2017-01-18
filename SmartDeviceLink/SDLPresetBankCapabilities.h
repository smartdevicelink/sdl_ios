//  SDLPresetBankCapabilities.h
//


#import "SDLRPCMessage.h"

/**
 * Contains information about on-screen preset capabilities.
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresetBankCapabilities : SDLRPCStruct

/**
 * @abstract If Onscreen custom presets are available.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *onScreenPresetsAvailable;

@end

NS_ASSUME_NONNULL_END
