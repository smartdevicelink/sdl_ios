//  SDLTTSChunkFactory.h
//

#import <Foundation/Foundation.h>

@class SDLTTSChunk;
@class SDLSpeechCapabilities;


__deprecated_msg("use SDLTTSChunk initializers instead") @interface SDLTTSChunkFactory : NSObject {
}

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities *)type __deprecated_msg("use SDLTTSChunk's initWithText:type: instead");
+ (NSMutableArray *)buildTTSChunksFromSimple:(NSString *)simple __deprecated_msg("use SDLTTSChunk's textChunksFromString: instead");

@end
