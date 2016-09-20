//  SDLTTSChunkFactory.h
//

#import <Foundation/Foundation.h>

@class SDLTTSChunk;
@class SDLSpeechCapabilities;


@interface SDLTTSChunkFactory : NSObject {
}

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities *)type;
+ (NSMutableArray<SDLTTSChunk *> *)buildTTSChunksFromSimple:(NSString *)simple;

@end
