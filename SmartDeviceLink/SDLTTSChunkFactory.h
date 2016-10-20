//  SDLTTSChunkFactory.h
//

#import <Foundation/Foundation.h>

#import "SDLSpeechCapabilities.h"

@class SDLTTSChunk;


@interface SDLTTSChunkFactory : NSObject {
}

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities)type;
+ (NSMutableArray<SDLTTSChunk *> *)buildTTSChunksFromSimple:(NSString *)simple;

@end
