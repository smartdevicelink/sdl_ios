//  SDLTTSChunkFactory.m
//

#import "SDLTTSChunkFactory.h"

#import "SDLTTSChunk.h"


@implementation SDLTTSChunkFactory

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities)type {
    SDLTTSChunk *ret = [[SDLTTSChunk alloc] init];
    ret.text = text;
    ret.type = type;

    return ret;
}

+ (NSMutableArray<SDLTTSChunk *> *)buildTTSChunksFromSimple:(NSString *)simple {
    if (simple == nil)
        return nil;

    return [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:simple type:SDLSpeechCapabilitiesText]];
}

@end
