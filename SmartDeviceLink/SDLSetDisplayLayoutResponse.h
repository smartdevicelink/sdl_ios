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
@interface SDLSetDisplayLayoutResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSetDisplayLayoutResponse object
 */
- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLDisplayCapabilities *displayCapabilities;
@property (strong) NSMutableArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (strong) NSMutableArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (strong) SDLPresetBankCapabilities *presetBankCapabilities;

@end
