//  SDLTTSChunkFactory.h
//




#import "SDLJingle.h"
#import "SDLTTSChunk.h"

@interface SDLTTSChunkFactory : NSObject {}

+(SDLTTSChunk*) buildTTSChunkForString:(NSString*) text type:(SDLSpeechCapabilities*)type;
+(NSMutableArray*) buildTTSChunksFromSimple:(NSString*) simple;

@end
