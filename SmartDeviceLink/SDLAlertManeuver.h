//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTTSChunk;


/**
 *  @since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertManeuver : SDLRPCRequest

- (instancetype)initWithTTS:(nullable NSString *)ttsText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;
- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

@property (nullable, strong) NSMutableArray<SDLTTSChunk *> *ttsChunks;
@property (nullable, strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
