//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTTSChunk;

/**
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSMutableArray<SDLTTSChunk *> *ttsChunks;
@property (strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end
