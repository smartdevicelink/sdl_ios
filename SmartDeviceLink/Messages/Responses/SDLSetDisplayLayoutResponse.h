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

@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities;

@end

NS_ASSUME_NONNULL_END
