//  SDLSetDisplayLayoutResponse.h
//

#import "SDLRPCResponse.h"

@class SDLDisplayCapabilities;
@class SDLPresetBankCapabilities;


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
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLDisplayCapabilities *displayCapabilities;
@property (strong) NSMutableArray *buttonCapabilities;
@property (strong) NSMutableArray *softButtonCapabilities;
@property (strong) SDLPresetBankCapabilities *presetBankCapabilities;

@end
