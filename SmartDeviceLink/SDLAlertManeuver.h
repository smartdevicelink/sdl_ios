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
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithTTS:(NSString *)ttsText softButtons:(NSArray<SDLSoftButton *> *)softButtons;
- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(NSArray<SDLSoftButton *> *)softButtons;

@property (strong) NSMutableArray *ttsChunks;
@property (strong) NSMutableArray *softButtons;

@end
