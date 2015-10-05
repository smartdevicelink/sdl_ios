//  SDLPresetBankCapabilities.h
//


#import "SDLRPCMessage.h"

/**
 * Contains information about on-screen preset capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLPresetBankCapabilities : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLPresetBankCapabilities object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLPresetBankCapabilities object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract If Onscreen custom presets are available.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *onScreenPresetsAvailable;

@end
