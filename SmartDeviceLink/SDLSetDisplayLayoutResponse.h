//  SDLSetDisplayLayoutResponse.h
//

#import "SDLRPCResponse.h"

@class SDLButtonCapabilities;
@class SDLDisplayCapabilities;
@class SDLPresetBankCapabilities;
@class SDLSoftButtonCapabilities;

/**
 * Set Display Layout Response is sent, when SetDisplayLayout has been called
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetDisplayLayoutResponse : SDLRPCResponse

@property (nullable, strong) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong) NSMutableArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong) NSMutableArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, strong) SDLPresetBankCapabilities *presetBankCapabilities;

@end

NS_ASSUME_NONNULL_END
