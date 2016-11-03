//  SDLTTSChunkFactory.h
//

#import <Foundation/Foundation.h>

#import "SDLSpeechCapabilities.h"

@class SDLTTSChunk;


__deprecated_msg("use SDLTTSChunk initializers instead") @interface SDLTTSChunkFactory : NSObject

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities)type __deprecated_msg("use SDLTTSChunk's initWithText:type: instead");
+ (NSMutableArray<SDLTTSChunk *> *)buildTTSChunksFromSimple:(NSString *)simple __deprecated_msg("use SDLTTSChunk's textChunksFromString: instead");

@end
