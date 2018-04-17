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
@interface SDLSetDisplayLayoutResponse : SDLRPCResponse

@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities;

@end

NS_ASSUME_NONNULL_END
