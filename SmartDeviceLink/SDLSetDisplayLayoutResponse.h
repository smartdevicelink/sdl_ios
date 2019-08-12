//  SDLSetDisplayLayoutResponse.h
//

#import "SDLRPCResponse.h"

@class SDLButtonCapabilities;
@class SDLDisplayCapabilities;
@class SDLPresetBankCapabilities;
@class SDLSoftButtonCapabilities;


NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLSetDisplayLayout

 Since SmartDeviceLink 2.0
 */
__deprecated_msg("This RPC is deprecated. Use Show RPC to change layout when connected to a 6.0+ head unit. Since sdl_ios v6.4 / RPC spec 6.0")
@interface SDLSetDisplayLayoutResponse : SDLRPCResponse

/**
 The display capabilities of the new template layout
 */
@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;

/**
 The button capabilities of the new template layout
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 The soft button capabilities of the new template layout
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 The preset bank capabilities of the new template layout
 */
@property (nullable, strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities;

@end

NS_ASSUME_NONNULL_END
