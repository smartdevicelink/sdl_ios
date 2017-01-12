//  SDLTTSChunkFactory.m
//

#import "SDLTTSChunkFactory.h"

#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTTSChunkFactory

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities)type {
    SDLTTSChunk *ret = [[SDLTTSChunk alloc] initWithText:text type:type];

    return ret;
}

+ (NSMutableArray<SDLTTSChunk *> *)buildTTSChunksFromSimple:(NSString *)simple {
    return [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:simple type:SDLSpeechCapabilitiesText]];
}

@end

NS_ASSUME_NONNULL_END
