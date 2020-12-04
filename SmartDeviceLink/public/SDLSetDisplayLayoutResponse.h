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
__deprecated_msg("Use SDLManager.screenManager.changeLayout() instead")
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
