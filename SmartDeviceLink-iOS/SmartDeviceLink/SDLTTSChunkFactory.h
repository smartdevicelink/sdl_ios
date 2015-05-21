//  SDLTTSChunkFactory.h
//

@import Foundation;

@class SDLTTSChunk;
@class SDLSpeechCapabilities;


@interface SDLTTSChunkFactory : NSObject {}

+(SDLTTSChunk*) buildTTSChunkForString:(NSString*) text type:(SDLSpeechCapabilities*)type;
+(NSMutableArray*) buildTTSChunksFromSimple:(NSString*) simple;

@end
