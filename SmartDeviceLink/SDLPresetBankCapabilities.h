//  SDLPresetBankCapabilities.h
//


#import "SDLRPCMessage.h"

/**
 * Contains information about on-screen preset capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLPresetBankCapabilities : SDLRPCStruct

/**
 * @abstract If Onscreen custom presets are available.
 *
 * Required, Boolean
 */
@property (strong) NSNumber<SDLBool> *onScreenPresetsAvailable;

@end
